const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const cors = require('cors');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
require('dotenv').config(); 


const app = express();
const port = 8000;

app.use(bodyParser.json());
app.use(cors());

let tokenBlacklist = [];
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  
  if (token == null) return res.sendStatus(401);
  
  if (tokenBlacklist.includes(token)) return res.status(403).json({ message: 'Token is blacklisted' });

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user; // { id: userId }
    next();
  });
}

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'hiba',
  database: 'rating'
});


app.post('/signup', (req, res) => {
  const { first_name, last_name, email, password, type } = req.body;

  if (!first_name || !last_name || !email || !password || !type) {
    return res.status(400).json({ error: "All fields are required" });
  }

  db.query("SELECT * FROM user WHERE email = ?", [email], (err, data) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (data.length > 0) {
      return res.status(400).json({ error: "User already exists" });
    } else {
      bcrypt.hash(password.toString(), 10, (err, hashedPassword) => {
        if (err) {
          console.error('Password hashing error:', err);
          return res.status(500).json({ error: "Error hashing password" });
        }

        db.query("INSERT INTO user (first_name, last_name, email, password, type) VALUES (?, ?, ?, ?, ?)",
          [first_name, last_name, email, hashedPassword, type], (err) => {
            if (err) {
              return res.status(500).json({ error: "Error inserting user into database", err: err });
            } else {
              
              const token = jwt.sign({ email: email }, process.env.JWT_SECRET, { expiresIn: '1d' });
              return res.status(201).json({ status: "Success", token: token  });
            }
          });
      });
    }
  });
});


  app.post('/login', (req, res) => {
    const {email,password} = req.body;

    if ( !email || !password ) {
        return res.status(400).json({ error: "All fields are required" });
      }

  db.query("SELECT * FROM user WHERE email = ?", [email], (err, data) => {
    if (err) return res.json({ Error: "Error fetching data from database.", err: err });
    if (data.length > 0) {
      bcrypt.compare(req.body.password.toString(), data[0].password, (err, response) => {
        if (err) return res.json({ Error: "Password compare error" });
        if (response) {
          
          const userType = data[0].type;
          const email = data[0].email;
          const token = jwt.sign({ email: email}, process.env.JWT_SECRET, { expiresIn: '1d' });
          return res.status(201).json({ Status: "Success", token: token, type: userType });
        } else {
          return res.json({ Error: "Password is incorrect!" });
        }
      });
    } else {
      return res.json({ Error: "email does not exist " });
    }
  });
});


app.post('/logout', authenticateToken, (req, res) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];
  
  tokenBlacklist.push(token);

  res.status(200).json({ message: 'Logout success' });
});




app.get('/user', authenticateToken, (req, res) => {
  const userEmail = req.user.email;

  const sql = `
    SELECT 
      u.id, 
      CONCAT(u.first_name, " ", u.last_name) AS name, 
      u.email, 
      ut.type, 
      u.points, 
      COUNT(t.id) AS completed_tasks 
    FROM 
      user u
    LEFT JOIN 
      task t ON u.id = t.developer AND t.status = 1
    LEFT JOIN 
      user_type ut ON u.type = ut.id
    WHERE 
      u.email = ?
    GROUP BY 
      u.id, u.first_name, u.last_name, u.email, ut.type, u.points
  `;

  db.query(sql, [userEmail], (err, results) => {
    if (err) {
      console.error('Database query error:', err);
      return res.status(500).send('Database query error');
    }
    res.status(200).json(results);
  });
});








app.get('/evaluation', (req, res) => {
  const sql = `
    SELECT 
    task.id AS taskId,
    task.name AS taskName,
    project.name AS projectName,
    project.github AS githubLink,
    task.branch AS taskBranch,
    CONCAT(user.first_name, ' ', user.last_name) AS userName,
    task.submition_date AS submissionDate
  FROM task
  INNER JOIN project ON task.project = project.id
  INNER JOIN user ON task.developer = user.id
  WHERE task.status = 2 AND task.branch IS NOT NULL AND task.submition_date IS NOT NULL
  `;

  db.query(sql, (err, results) => {
    if (err) {
      console.error('Error executing query:', err);
      res.status(500).json({ error: 'Internal Server Error' });
      return;
    }
    res.json({ data: results });
  });
});


app.post('/confirm', (req, res) => {
  const { task } = req.body;

  // SQL queries
  const getUserSql = 'SELECT developer FROM task WHERE id = ?';
  const updateTaskSql = 'UPDATE task SET status = 1 WHERE id = ?';
  const updateUserSql = 'UPDATE user SET points = points + 10 WHERE id = ?';

  // Step 1: Retrieve the user ID associated with the task
  db.query(getUserSql, [task], (err, results) => {
    if (err) {
      console.error('Error fetching the user ID:', err);
      res.status(500).send('Error fetching the user ID');
      return;
    }

    if (results.length === 0) {
      res.status(404).send('Task not found');
      return;
    }

    const userId = results[0].developer;

    // Step 2: Update the task status
    db.query(updateTaskSql, [task], (err) => {
      if (err) {
        console.error('Error updating the task status:', err);
        res.status(500).send('Error updating the task status');
        return;
      }

      // Step 3: Update the user's points
      db.query(updateUserSql, [userId], (err) => {
        if (err) {
          console.error('Error updating the user points:', err);
          res.status(500).send('Error updating the user points');
          return;
        }

        res.send('Status and points updated successfully');
      });
    });
  });
});



app.post('/decline', (req, res) => {
  const { task } = req.body;

  // Step 1: Fetch the deadline and developer for the task
  const fetchDeadlineSql = 'SELECT deadline, developer FROM task WHERE id = ?';
  db.query(fetchDeadlineSql, [task], (err, results) => {
    if (err) {
      res.status(500).send('Error fetching the deadline');
      return;
    }

    if (results.length === 0) {
      res.status(404).send('Task not found');
      return;
    }

    const { deadline, developer } = results[0];

    // Step 2: Fetch the submission date
    const fetchSubmissionSql = 'SELECT submition_date FROM task WHERE id = ?';
    db.query(fetchSubmissionSql, [task], (err, results) => {
      if (err) {
        res.status(500).send('Error fetching the submission date');
        return;
      }

      if (results.length === 0) {
        res.status(404).send('Task submission not found');
        return;
      }

      const submissionDate = results[0].submition_date;

      // Convert deadline and submissionDate to Date objects if they are not already
      const deadlineDate = new Date(deadline);
      const submissionDateDate = new Date(submissionDate);

      let updateTaskSql;
      let updateParams;

      if (submissionDateDate <= deadlineDate) {
        // Step 3a: If the submission date is before or on the deadline, set branch and submission date to NULL
        updateTaskSql = 'UPDATE task SET branch = NULL, submition_date = NULL WHERE id = ?';
        updateParams = [task];
      } else {
        // Step 3b: Otherwise, update the task status and deduct points
        updateTaskSql = 'UPDATE task SET status = 3 WHERE id = ?';
        updateParams = [task];

        // Deduct 10 points from the user's score
        const updateUserSql = 'UPDATE user SET points = points - 10 WHERE id = ?';
        db.query(updateUserSql, [developer], (err) => {
          if (err) {
            console.error('Error updating user points:', err);
            // Log the error but continue with the task update
          }
        });
      }

      db.query(updateTaskSql, updateParams, (err) => {
        if (err) {
          res.status(500).send('Error updating the task');
          return;
        }
        res.send('Task status updated successfully');
      });
    });
  });
});




// Route pour obtenir l'historique des tâches de l'utilisateur
app.get('/tasks', authenticateToken, (req, res) => {
  const query = `
    SELECT 
      task.id, 
      task.name AS taskName, 
      task.deadline AS date, 
      project.name AS projectName,  
      task.status AS status
    FROM 
      task
    JOIN 
      project ON task.project = project.id
    JOIN 
      user ON task.developer = user.id
    WHERE 
      (task.status = 1 OR task.status = 3)
  `;

  db.query(query, (err, results) => {
    if (err) {
      console.log(err); // Log the error
      res.status(500).json({ error: err });
      return;
    }
    res.json({ data: results });
  });
});





// Route to fetch all user names
app.get('/users', (req, res) => {
  const sql = 'SELECT id, CONCAT(first_name, " ", last_name) AS name FROM user';
  db.query(sql, (err, results) => {
      if (err) {
          console.error('Database query error:', err);
          return res.status(500).send('Database query error');
      }
      res.status(200).json(results);
  });
});

// Route to fetch all projects
app.get('/projects', (req, res) => {
  const sql = 'SELECT id, name FROM project';
  db.query(sql, (err, results) => {
      if (err) {
          console.error('Database query error:', err);
          return res.status(500).send('Database query error');
      }
      res.status(200).json(results);
  });
});

// Route to create a task
app.post('/createtask', (req, res) => {
  const { name, description, deadline, branch, project, developer } = req.body;

  const sql = 'INSERT INTO task (name, description, deadline, branch, project, developer, status) VALUES (?, ?, ?, ?, ?, ?, ?)';
  
  db.query(sql, [name, description, deadline, branch, project, developer, 2], (err, result) => {
      if (err) {
          console.error('Database insertion error:', err);
          return res.status(500).send('Database insertion error');
      }
      res.status(200).send('Task created successfully');
  });
});

// Route to handle project creation
app.post('/create-project', (req, res) => {
  const { name, description, github, team } = req.body;

  const sql = 'INSERT INTO project (name, description, github, team) VALUES (?, ?, ?, ?)';
  db.query(sql, [name, description, github, team], (err, result) => {
      if (err) {
          console.error('Database query error:', err);
          return res.status(500).send('Database query error');
      }
      res.send({ id: result.insertId, message: 'Project created successfully' });
  });
});


//get to get user project's 

app.get('/project_s', authenticateToken, (req, res) => {
  // Extract the user's email or ID from the token
  const userEmail = req.user.email;

  // Query to fetch projects based on the authenticated user
  const query = `
      SELECT project.id , project.name AS title , project.description, project.github 
      FROM task 
      JOIN project ON task.project = project.id 
      JOIN user ON task.developer = user.id
      WHERE task.status = 2 AND user.email = ?
      GROUP BY project.id
  `;

  db.query(query, [userEmail], (err, result) => {
      if (err) {
          console.error('Error fetching data from the database:', err);
          return res.status(500).json({ Error: "Error fetching data from the database." });
      }

      return res.json({ Status: "Success", data: result });
  });
});


app.get('/tasks_per_project', authenticateToken, (req, res) => {
  const userEmail = req.user.email;

  const sql = `
    SELECT 
      task.id, 
      task.name AS taskName, 
      task.description, 
      task.deadline,  
      task.project,
      project.name AS projectName 
    FROM 
      task 
    JOIN 
      project ON task.project = project.id 
    JOIN 
      user ON task.developer = user.id
    WHERE 
      task.status = 2 AND user.email = ? AND task.branch IS NULL
  `;

  db.query(sql, [userEmail], (err, result) => {
      if (err) {
          console.error('Error fetching tasks:', err);
          return res.status(500).json({ Error: "Error fetching tasks.", err });
      }
      return res.json({ Status: "Success", data: result });
  });
});

app.post('/submit_task', (req, res) => {
  const data = [req.body.branch, req.body.submition_date];

  const sql = 'UPDATE task SET branch = ? ,submition_date = ? where id = ?';
  
  db.query(sql, [...data,req.body.id], (err, result) => {
      if (err) {
          console.error('error submitting task :', err);
          return res.status(500).send({Error: "Error submitting task.", err});
      }
      res.status(200).send('Task submitted successfully');
  });
});




app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

