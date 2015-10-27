# Caravan [![NPM version][npm-image]][npm] [![Build Status][travis-image]][travis] [![Coverage Status][coveralls-image]][coveralls]

[![Sauce Test Status][sauce-image]][sauce]

> throttle REST request client.

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
<script src="https://cdn.rawgit.com/59naga/caravan/96e63a0476b31e5b724e85bcf2ae6019cc5a1da3/caravan.min.js"></script>
<script>
  console.log(caravan); //function
</script>
```

# API

## caravan(urls,options) -> Promise(response*s*)

Do throttle request to `urls`. return the *bodies* and errors.
It is handled one by one, but can change at `options.concurrency`.

```js
var urls= [
  'http://romanize.berabou.me/foo',
  'http://romanize.berabou.me/bar',
  'http://romanize.berabou.me/baz',
  'http://localhost:404/notfound',
];

// do serial (slowly)
caravan(urls).then(console.log.bind(console));
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

// do parallel (quickly)
caravan(urls,{concurrency:4}).then(console.log.bind(console));

// do graceful (wait a ms)
caravan(urls,{delay:2000}).then(console.log.bind(console));
```

Or, usage follows.

```js
caravan.get('http://romanize.berabou.me/foo').then(console.log.bind(console));
caravan.get(['http://romanize.berabou.me/bar']).then(console.log.bind(console));

caravan.post('http://romanize.berabou.me/baz').then(console.log.bind(console));
caravan.put('http://romanize.berabou.me/beep').then(console.log.bind(console));
caravan.delete('http://romanize.berabou.me/boop').then(console.log.bind(console));
```

### Customize request

If passing an object to the `urls`, can switch the verb, and send a header and data.

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

#### `delay`: number (default:`1`)

Specify the delay a millsecond for next request.

```js
var urls= [
  'http://example.com/',
  'http://example.com/',
];

console.time('deferred');
caravan(url,{delay:1000})
.then(function(){
  console.timeEnd('deferred');
});
// deferred: 1s
```

#### `concurrency`: number (default:`1`)

Specify the number of throttle requests.

```js
var urls= [
  'http://localhost/ping/1s',
  'http://localhost/ping/2s',
  'http://localhost/ping/3s',
];

console.time('concurrency is 1');
caravan(url,{concurrency:1})
.then(function(){
  console.timeEnd('concurrency is 1');
});
// concurrency is 1: 6s

console.time('concurrency is 3');
caravan(url,{concurrency:3})
.then(function(){
  console.timeEnd('concurrency is 3');
});
// concurrency is 3: 3s
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
