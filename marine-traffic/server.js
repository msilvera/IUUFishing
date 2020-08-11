const http = require('http');
const express = require('express');
const itemsRouter = require('./mt.routes');
const app = express();

app.use(express.json());

app.use('/api', itemsRouter);
app.use('/', function(req, res) {
    res.send('todo api works');
});
const server = http.createServer(app);
const port = 5000;
server.listen(port);
console.debug('Server listening on port ' + port);