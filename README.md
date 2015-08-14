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
console.log(caravan); //object
```

### Via bower

```bash
$ bower install caravan --save
```

```html
<script src="bower_components/caravan/caravan.min.js"></script>
<script>
  console.log(caravan); //object
</script>
```

# API

## .fetchAll(requests,options) -> Promise(responses)

Do throttle request to requests. return the bodies and errors.

```js
caravan.fetchAll([
  'http://romanize.berabou.me/foo',
  {url:'http://romanize.berabou.me/bar'},
  {url:'http://romanize.berabou.me/baz',method:'GET'},
  'http://localhost:404/notfound',
])
.then(console.log);
//[
//  '"foo"',
//  '"bar"',
//  '"baz"',
//  {
//    [Error: connect ECONNREFUSED]
//    code: 'ECONNREFUSED',
//    errno: 'ECONNREFUSED',
//    syscall: 'connect'
//  }
//]
```

### Options

#### `concurrency`: number (default:1)

Specify the number of throttle requests.

```js
var requests= [
  'http://localhost/ping/1s',
  {url:'http://localhost/ping/2s'},
  {url:'http://localhost/ping/3s',method:'GET'},
];

var begin1= Date.now();
caravan.fetchAll(requests,{concurrency:1})
.then(function(){
  console.log('concurrency is 1 =>',Date.now()-begin1);
});
// concurrency is 1 => 6029

var begin2= Date.now();
caravan.fetchAll(requests,{concurrency:3})
.then(function(){
  console.log('concurrency is 3 =>',Date.now()-begin2);
});
// concurrency is 3 => 3014
```

# See also 
* [request(via npm)](https://github.com/request/request#readme)
* [xhr(via bower)](https://github.com/Raynos/xhr#readme)

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
