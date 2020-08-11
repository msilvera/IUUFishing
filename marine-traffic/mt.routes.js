const express = require('express');
const router = express.Router();
const mt_api = require('./marine-traffic-api');


router.get('/', function (req, res) {
    resp = mt_api.queryMarineTrafficAPI();
    res.status(200).json(resp);
});
/*
router.get('/:id', function (req, res) {
    let found = data.find(function (item) {
        return item.id === parseInt(req.params.id);
    });
    if (found) {
        res.status(200).json(found);
    } else {
        res.sendStatus(404);
    }
});
*/
module.exports = router;