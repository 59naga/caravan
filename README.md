# Caravan [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

[![Sauce Test Status][sauce-image]][sauce]

> throttle requests for easy to scrape.

## Installation
### Via npm

```bash
$ npm install caravan --save
```

```js
var caravan= require('caravan');
console.log(caravan); //function
```

### Via bower

```bash
$ bower install caravan --save
```

```html
<script src="bower_components/caravan/caravan.min.js"></script>
<script>
  console.log(caravan); //function
</script>
```

### Via rawgit.com(the simple way)

```html
<script src="https://cdn.rawgit.com/59naga/caravan/7f56f3ca96d5b4c3597c91c41a204df5adb363f3/caravan.min.js"></script>
<script>
  console.log(caravan); //function
</script>
```

# API

## caravan(urls,options) -> Promise(responses)

Do throttle request to urls. return the bodies and errors.

```js
caravan([
  'http://romanize.berabou.me/foo',
  'http://romanize.berabou.me/bar',
  'http://romanize.berabou.me/baz',
  'http://localhost:404/notfound',
])
.then(console.log);
//[
//  'foo',
//  'bar',
//  'baz',
//  {
//    [Error: connect ECONNREFUSED]
//    code: 'ECONNREFUSED',
//    errno: 'ECONNREFUSED',
//    syscall: 'connect'
//  }
//]
```

### Customize request

If passing an object to the `urls`, can switch the verb, and send a header.

#### `url/uri`: string
#### `method`: string (default:`'GET'`)
#### `headers`: object (default:`null`)
#### `data`: object (default:`null`)

It uses as an argument of [superagent](https://github.com/visionmedia/superagent#installation)

```js
caravan([
  {
    url: 'http://superserver.berabou.me/1',
    method: 'GET',
    headers: {foo:'bar'},
    data: {baz:'beep'},
  },
  {
    url: 'http://superserver.berabou.me/2',
    method: 'POST',
    headers: {foo:'bar'},
    data: {baz:'beep'},
  },
  {
    url: 'http://superserver.berabou.me/3',
    method: 'PUT',
    headers: {foo:'bar'},
    data: {baz:'beep'},
  },
  {
    url: 'http://superserver.berabou.me/4',
    method: 'DELETE',
    headers: {foo:'bar'},
    data: {baz:'beep'},
  },
])
.then(function(responses){
  console.log(response) // verbs result
});
```

### Caravan options

#### `concurrency`: number (default:`1`)

Specify the number of throttle requests.

```js
var url= [
  'http://localhost/ping/1s',
  'http://localhost/ping/2s',
  'http://localhost/ping/3s',
];

console.time('concurrency is 1');
caravan(url,{concurrency:1})
.then(function(){
  console.timeEnd('concurrency is 1');
});
// concurrency is 1: 3s

console.time('concurrency is 3');
caravan(url,{concurrency:3})
.then(function(){
  console.timeEnd('concurrency is 3');
});
// concurrency is 3: 1s
```

#### `raw`: bool (default:`false`)

if true, response contains detailed information such as headers, statuscode...

```js
caravan('http://romanize.berabou.me/foo',{raw:true})
.then(function(responses){
  console.log(responses[0]);
  // {
  //   ...
  //   links: {},
  //   text: '"foo"',
  //   body: 'foo',
  //   files: {},
  //   buffered: true,
  //   headers: 
  //    { 'x-powered-by': 'Express',
  //      'access-control-allow-origin': '*',
  //      'access-control-allow-headers': 'Content-Type',
  //      'access-control-allow-methods': 'PUT, GET, POST, DELETE, OPTIONS',
  //      'content-type': 'application/json; charset=utf-8',
  //      'content-length': '5',
  //      etag: 'W/"5-DbpSDjNcBrqSQKl46UVYeA"',
  //      date: 'Mon, 26 Oct 2015 07:55:43 GMT',
  //      connection: 'close' },
  //   header: { ... },
  //   statusCode: 200,
  //   status: 200,
  //   statusType: 2,
  //   info: false,
  //   ok: true,
  //   ...
  // }
});
```

License
---
[MIT][License]

[License]: http://59naga.mit-license.org/

[sauce-image]: http://soysauce.berabou.me/u/59798/caravan.svg
[sauce]: https://saucelabs.com/u/59798
[npm-image]:https://img.shields.io/npm/v/caravan.svg?style=flat-square
[npm]: https://npmjs.org/package/caravan
[travis-image]: http://img.shields.io/travis/59naga/caravan.svg?style=flat-square
[travis]: https://travis-ci.org/59naga/caravan
[coveralls-image]: http://img.shields.io/coveralls/59naga/caravan.svg?style=flat-square
[coveralls]: https://coveralls.io/r/59naga/caravan?branch=master
