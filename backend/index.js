const express = require('express');
const mainRoutes = require('./routes/routes');

const app = express();

app.use(express.json()); // Middleware to parse JSON requests

app.use('/', mainRoutes);


const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
