( function _Units_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
  require( '../l5/Units.s' );
  _.include( 'wTesting' );
}

const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

// --
// tests
// --

function strMetricFormat( test )
{
  test.case = 'default options, number is integer';
  var got = _.units.strMetricFormat( '100m' );
  var expected = '100.0 ';
  test.identical( got, expected );
  test.notIdentical( got, '100 ' );

  test.case = 'default options, number is float';
  var got = _.units.strMetricFormat( 0.001, undefined );
  var expected = '1.0 m';
  test.identical( got, expected );
  test.notIdentical( got, '0.005 ' );

  test.case = 'number to million';
  var got = _.units.strMetricFormat( 1, { metric : 6 } );
  var expected = '1.0 M';
  test.identical( got, expected );
  test.notIdentical( got, '1000000 ' );

  test.case = 'number to milli';
  var got = _.units.strMetricFormat( 1, { metric : -3 } );
  var expected = '1.0 m';
  test.identical( got, expected );
  test.notIdentical( got, '0.001 ' );

  test.case = 'metric out of range';
  var got = _.units.strMetricFormat( 10, { metric : 25 } );
  var expected = '10.0 ';
  test.identical( got, expected );
  test.notIdentical( got, '10.0 y' );

  test.case = 'fixed : 0';
  var got = _.units.strMetricFormat( '1300', { fixed : 0 } );
  var expected = '1 k';
  test.identical( got, expected );

  var got = _.units.strMetricFormat( '0.005', { fixed : 0 } );
  var expected = '5 m';
  test.identical( got, expected );

  test.case = 'divisor only ';
  var got = _.units.strMetricFormat( '1000000', { divisor : 3 } );
  var expected = '1.0 M';
  test.identical( got, expected );

  var got = _.units.strMetricFormat( '3200000000', { divisor : 3 } );
  var expected = '3.2 G';
  test.identical( got, expected );

  var got = _.units.strMetricFormat( '2000', { divisor : 3 } );
  var expected = '2.0 k';
  test.identical( got, expected );

  var got = _.units.strMetricFormat( 0.000002, { divisor : 3 } );
  var expected = '2.0 μ';
  test.identical( got, expected );

  var got = _.units.strMetricFormat( 0.000000003, { divisor : 3 } );
  var expected = '3.0 n';
  test.identical( got, expected );

  var got = _.units.strMetricFormat( 0.002, { divisor : 3 } );
  var expected = '2.0 m';
  test.identical( got, expected );

  var got = _.units.strMetricFormat( 0.000001, { divisor : 3 } );
  var expected = '1.0 μ';
  test.identical( got, expected );

  test.case = 'divisor, thousand test';
  var got = _.units.strMetricFormat( '1000000', { divisor : 2, thousand : 100 } );
  var expected = '1.0 M';
  test.identical( got, expected );

  var got = _.units.strMetricFormat( 0.000002, { divisor : 2, thousand : 100 } );
  var expected = '2.0 μ';
  test.identical( got, expected );

  var got = _.units.strMetricFormat( 0.000001, { divisor : 2, thousand : 100 } );
  var expected = '1.0 μ';
  test.identical( got, expected );

  test.case = 'divisor, thousand, dimensions, metric test';
  var got = _.units.strMetricFormat( '10000', { divisor : 2, thousand : 10, dimensions : 3, metric : 1 } );
  var expected = '10.0 k';
  test.identical( got, expected );

  var got = _.units.strMetricFormat( '-0.0001', { divisor : 3, thousand : 10, dimensions : 3, metric : 0 } );
  var expected = '-100.0 μ';
  test.identical( got, expected );

  test.case = 'divisor, thousand, dimensions test';
  var got = _.units.strMetricFormat( '10000', { divisor : 2, thousand : 10, dimensions : 3 } );
  var expected = '10.0 h';
  test.identical( got, expected );

  var got = _.units.strMetricFormat( '0.0001', { divisor : 3, thousand : 10, dimensions : 3 } );
  var expected = '100.0 μ';
  test.identical( got, expected );

  test.case = 'divisor, thousand, dimensions, fixed test';
  var got = _.units.strMetricFormat( '10000', { divisor : 2, thousand : 10, dimensions : 3, fixed : 0 } );
  var expected = '10 h';
  test.identical( got, expected );

  test.case = 'o.metrics';
  var got = _.units.strMetricFormat( '10000', { 'metrics' : { '3' : { name : 'kilo', symbol : 'k', word : 'thousand' }, 'range' : [ 0, 30 ] } } );
  var expected = '10.0 k';
  test.identical( got, expected );

  var got = _.units.strMetricFormat( '0.0001', { divisor : 3, thousand : 10, dimensions : 3, fixed : 0 } );
  var expected = '100 μ';
  test.identical( got, expected );

  test.case = 'first arg is Not a Number';
  var got = _.units.strMetricFormat( '[a]', undefined );
  var expected = 'NaN ';
  test.identical( got, expected );

  /**/

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.units.strMetricFormat() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.units.strMetricFormat( '1', { fixed : 0 }, '3' ) );

  test.case = 'wrong first argument';
  test.shouldThrowErrorSync( () => _.units.strMetricFormat( null, { fixed : 1 } ) );
  test.shouldThrowErrorSync( () => _.units.strMetricFormat( undefined, { fixed : 1 } ) );
  test.shouldThrowErrorSync( () => _.units.strMetricFormat( { 1 : 1 }, { fixed : 1 } ) );
  test.shouldThrowErrorSync( () => _.units.strMetricFormat( [ 1 ], { fixed : 1 } ) );

  test.case = 'wrong second argument';
  test.shouldThrowErrorSync( () => _.units.strMetricFormat( 1, 1 ) );
  test.shouldThrowErrorSync( () => _.units.strMetricFormat( 1, '0' ) );

  test.case = 'fixed out of range';
  test.shouldThrowErrorSync( () => _.units.strMetricFormat( '1300', { fixed : 21 } ) );

  test.case = 'fixed is not a number';
  test.shouldThrowErrorSync( () => _.units.strMetricFormat( '1300', { fixed : [ 1 ] } ) );
}

//

function strMetricFormatBytes( test )
{
  test.case = 'zero';
  var got = _.units.strMetricFormatBytes( 0 );
  var expected = '0.0 b';
  test.identical( got, expected );

  test.case = 'string zero';
  var got = _.units.strMetricFormatBytes( '0' );
  var expected = '0.0 b';
  test.identical( got, expected );

  test.case = 'string';
  var got = _.units.strMetricFormatBytes( '1000000' );
  var expected = '976.6 kb';
  test.identical( got, expected );

  test.case = 'default options';
  var got = _.units.strMetricFormatBytes( 1024 );
  var expected = '1.0 kb';
  test.identical( got, expected );

  test.case = 'default options';
  var got = _.units.strMetricFormatBytes( 2500 );
  var expected = '2.4 kb';
  test.identical( got, expected );

  test.case = 'fixed';
  var got = _.units.strMetricFormatBytes( 2500, { fixed : 0 } );
  var expected = '2 kb';
  test.identical( got, expected );

  test.case = 'invalid metric value';
  var got = _.units.strMetricFormatBytes( 2500, { metric : 4 } );
  var expected = '2500.0 b';
  test.identical( got, expected );

  test.case = 'divisor test';
  var got = _.units.strMetricFormatBytes( Math.pow( 2, 32 ), { divisor : 4, thousand : 1024 } );
  var expected = '4.0 Tb';
  test.identical( got, expected );


  /**/

  if( !Config.debug )
  return;

  test.case = 'invalid first argument type';
  test.shouldThrowErrorOfAnyKind( function()
  {
    _.units.strMetricFormatBytes( [ '1', '2', '3' ] );
  });

  test.case = 'invalid second argument type';
  test.shouldThrowErrorOfAnyKind( function()
  {
    _.units.strMetricFormatBytes( 0, '0' );
  });

  test.case = 'no arguments';
  test.shouldThrowErrorOfAnyKind( function()
  {
    _.units.strMetricFormatBytes();
  });

  test.case = 'fixed out of range';
  test.shouldThrowErrorOfAnyKind( function()
  {
    _.units.strMetricFormatBytes( '1300', { fixed : 22 } );
  });

  test.case = 'not enough arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strMetricFormatBytes() );

  test.case = 'too many arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strMetricFormatBytes( 1, 1 ) );

  test.case = 'bad arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strMetricFormatBytes( null ) );

  test.case = 'bad arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strMetricFormatBytes( undefined ) );

  test.case = 'bad arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strMetricFormatBytes( {} ) );

  test.case = 'bad arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strMetricFormatBytes( [] ) );
}

//

function strToBytes( test )
{
  test.case = 'simple string';
  var got = _.units.strToBytes( 'abcd' );
  var expected = new U8x ( [ 97, 98, 99, 100 ] );
  test.identical( got, expected );

  test.case = 'escaping';
  var got = _.units.strToBytes( '\u001bABC\n\t' );
  var expected = new U8x ( [ 27, 65, 66, 67, 10, 9 ] );
  test.identical( got, expected );

  test.case = 'zero length';
  var got = _.units.strToBytes( '' );
  var expected = new U8x ( [ ] );
  test.identical( got, expected );

  test.case = 'returns the typed-array';
  var got = _.units.strToBytes( 'abc' );
  var expected = got;
  test.identical( got, expected );

  /**/

  if( !Config.debug )
  return;

  test.case = 'invalid arguments count';
  test.shouldThrowErrorOfAnyKind( function()
  {
    _.units.strToBytes( '1', '2' );
  });

  test.case = 'invalid argument type';
  test.shouldThrowErrorOfAnyKind( function()
  {
    _.units.strToBytes( 0 );
  });

  test.case = 'no arguments';
  test.shouldThrowErrorOfAnyKind( function()
  {
    _.units.strToBytes();
  });

  test.case = 'argument is wrong';
  test.shouldThrowErrorOfAnyKind( function( )
  {
    _.units.strToBytes( [ ] );
  } );

  test.case = 'argument is wrong';
  test.shouldThrowErrorOfAnyKind( function( )
  {
    _.units.strToBytes( 13 );
  } );

  test.case = 'not enough arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strToBytes() );

  test.case = 'too many arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strToBytes( 1, 1 ) );

  test.case = 'bad arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strToBytes( null ) );

  test.case = 'bad arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strToBytes( undefined ) );

  test.case = 'bad arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strToBytes( {} ) );

  test.case = 'bad arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strToBytes( [] ) );
}

//

function strTimeFormat( test )
{
  test.case = 'simple number';
  var got = _.units.strTimeFormat( 0 );
  var expected = '0.000 s';
  test.identical( got, expected );

  test.case = 'simple number';
  var got = _.units.strTimeFormat( 1000 );
  var expected = '1.000 s';
  test.identical( got, expected );

  test.case = 'simple number';
  var got = _.units.strTimeFormat( 1 );
  var expected = '1.000 ms';
  test.identical( got, expected );

  test.case = 'big number';
  var got = _.units.strTimeFormat( Math.pow( 4, 7 ) );
  var expected = '16.384 s';
  test.identical( got, expected );

  test.case = 'very big number';
  var got = _.units.strTimeFormat( Math.pow( 13, 13 ) );
  var expected = '302.875 Gs';
  test.identical( got, expected );

  test.case = 'zero';
  var got = _.units.strTimeFormat( 0 );
  var expected = '0.000 s';
  test.identical( got, expected );

  test.case = 'from date';
  var d = new Date( 1, 2, 3 )
  var got = _.units.strTimeFormat( d );
  var expected = '-2.172 Gs';
  test.identical( got, expected );

  /**/

  if( !Config.debug )
  return;

  test.case = 'not enough arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strTimeFormat() );

  test.case = 'too many arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strTimeFormat( 1, 1 ) );

  test.case = 'bad arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strTimeFormat( null ) );

  test.case = 'bad arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strTimeFormat( undefined ) );

  test.case = 'bad arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strTimeFormat( {} ) );

  test.case = 'bad arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strTimeFormat( [] ) );

  test.case = 'bad arguments';
  test.shouldThrowErrorOfAnyKind( () => _.units.strTimeFormat( '24:00' ) );
}

// --
// declare
// --

const Proto =
{
  name : 'Tools.Units',
  silencing : 1,

  tests :
  {
    strMetricFormat,
    strMetricFormatBytes,
    strToBytes,
    strTimeFormat,
  },
};

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
