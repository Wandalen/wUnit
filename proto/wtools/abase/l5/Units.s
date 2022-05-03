( function _Units_s_()
{

'use strict';

/**
 * Collection of sophisticated routines for operations with different units.
 * @module Tools/base/l5/Units
 * @extends Tools
*/

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../node_modules/Tools' );
}

const _ = _global_.wTools;
_.units = _.units || Object.create( null );

// --
// format
// --

/**
 * Converts string( str ) to array of unsigned 8-bit integers.
 *
 * @param {string} str - Source string to convert.
 * @returns {typedArray} Returns typed array that represents string characters in 8-bit unsigned integers.
 *
 * @example
 * //returns [ 101, 120, 97, 109, 112, 108, 101 ]
 * _.units.strToBytes( 'example' );
 *
 * @function  strToBytes
 * @throws { Exception } Throws a exception if( src ) is not a String.
 * @throws { Exception } Throws a exception if no argument provided.
 * @namespace Tools
 * @module Tools/base/l5/StringTools
 *
 */

function strToBytes( src )
{

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strIs( src ) );

  let result = new U8x( src.length );

  for( let s = 0, sl = src.length ; s < sl ; s++ )
  {
    result[ s ] = src.charCodeAt( s );
  }

  return result;
}

//

/**
* @summary Contains metric prefixes.
* @enum {} _metrics
* @module Tools/base/l5/StringTools
*/

let _metrics =
{

  '24'  : { name : 'yotta', symbol : 'Y', word : 'septillion' },
  '21'  : { name : 'zetta', symbol : 'Z', word : 'sextillion' },
  '18'  : { name : 'exa', symbol : 'E', word : 'quintillion' },
  '15'  : { name : 'peta', symbol : 'P', word : 'quadrillion' },
  '12'  : { name : 'tera', symbol : 'T', word : 'trillion' },
  '9'   : { name : 'giga', symbol : 'G', word : 'billion' },
  '6'   : { name : 'mega', symbol : 'M', word : 'million' },
  '3'   : { name : 'kilo', symbol : 'k', word : 'thousand' },
  '2'   : { name : 'hecto', symbol : 'h', word : 'hundred' },
  '1'   : { name : 'deca', symbol : 'da', word : 'ten' },

  '0'   : { name : '', symbol : '', word : '' },

  '-1'  : { name : 'deci', symbol : 'd', word : 'tenth' },
  '-2'  : { name : 'centi', symbol : 'c', word : 'hundredth' },
  '-3'  : { name : 'milli', symbol : 'm', word : 'thousandth' },
  '-6'  : { name : 'micro', symbol : 'μ', word : 'millionth' },
  '-9'  : { name : 'nano', symbol : 'n', word : 'billionth' },
  '-12' : { name : 'pico', symbol : 'p', word : 'trillionth' },
  '-15' : { name : 'femto', symbol : 'f', word : 'quadrillionth' },
  '-18' : { name : 'atto', symbol : 'a', word : 'quintillionth' },
  '-21' : { name : 'zepto', symbol : 'z', word : 'sextillionth' },
  '-24' : { name : 'yocto', symbol : 'y', word : 'septillionth' },

  'range' : [ -24, +24 ],

}

/**
 * Returns string that represents number( src ) with metric unit prefix that depends on options( o ).
 * If no options provided function start calculating metric with default options.
 * Example: for number ( 50000 ) function returns ( "50.0 k" ), where "k"- thousand.
 *
 * @param {(number|string)} src - Source object.
 * @param {object} o - conversion options.
 * @param {number} [ o.divisor=3 ] - Sets count of number divisors.
 * @param {number} [ o.thousand=1000 ] - Sets integer power of one thousand.
 * @param {boolean} [ o.fixed=1 ] - The number of digits to appear after the decimal point, example : [ '58912.001' ].
 * Number must be between 0 and 20.
 * @param {number} [ o.dimensions=1 ] - Sets exponent of a number.
 * @param {number} [ o.metric=0 ] - Sets the metric unit type from the map( _metrics ).
 * @returns {string} Returns number with metric prefix as a string.
 *
 * @example
 * //returns "1.0 M"
 * _.units.strMetricFormat( 1, { metric : 6 } );
 *
 * @example
 * //returns "100.0 "
 * _.units.strMetricFormat( "100m", { } );
 *
 * @example
 * //returns "100.0 T
 * _.units.strMetricFormat( "100m", { metric : 12 } );
 *
 * @example
 * //returns "2 k"
 * _.units.strMetricFormat( "1500", { fixed : 0 } );
 *
 * @example
 * //returns "1.0 M"
 * _.units.strMetricFormat( "1000000",{ divisor : 2, thousand : 100 } );
 *
 * @example
 * //returns "10.0 h"
 * _.units.strMetricFormat( "10000", { divisor : 2, thousand : 10, dimensions : 3 } );
 *
 * @function strMetricFormat
 * @namespace Tools
 * @module Tools/base/l5/StringTools
 *
 */

/* qqq : cover routine strMetricFormat */ /* aaa : Dmytro : covered */
/* xxx : use it for time measurement */

function strMetricFormat( number, o )
{

  if( _.strIs( number ) )
  number = parseFloat( number );

  o = _.routine.options_( strMetricFormat, o || null );

  if( o.metrics === null )
  o.metrics = _metrics;

  _.assert( _.numberIs( number ), '"number" should be Number' );
  _.assert( arguments.length === 1 || arguments.length === 2 );
  _.assert( _.object.isBasic( o ) || o === undefined, 'Expects map {-o-}' );
  _.assert( _.numberIs( o.fixed ) );
  _.assert( o.fixed <= 20 );

  let original = number;

  if( o.dimensions !== 1 )
  o.thousand = Math.pow( o.thousand, o.dimensions );

  if( number !== 0 )
  {

    if( Math.abs( number ) >= o.thousand )
    {

      while( Math.abs( number ) >= o.thousand || !o.metrics[ String( o.metric ) ] )
      {

        if( o.metric + o.divisor > o.metrics.range[ 1 ] )
        break;

        number /= o.thousand;
        o.metric += o.divisor;

      }

    }
    else if( Math.abs( number ) < 1 )
    {

      while( Math.abs( number ) < 1 || !o.metrics[ String( o.metric ) ] )
      {

        if( o.metric - o.divisor < o.metrics.range[ 0 ] )
        break;

        number *= o.thousand;
        o.metric -= o.divisor;

      }

      if( number / o.thousand > 1 )
      {
        let o2 =
        {
          thousand : o.thousand,
          metric : o.metric,
          fixed : o.fixed,
          divisor : o.divisor,
          metrics : o.metrics,
          dimensions : o.dimensions
        };
        return strMetricFormat( number, o2 );
      }

    }

  }

  let result = '';

  if( o.metrics[ String( o.metric ) ] )
  {
    result = number.toFixed( o.fixed ) + ' ' + o.metrics[ String( o.metric ) ].symbol;
  }
  else
  {
    result = original.toFixed( o.fixed ) + ' ';
  }

  return result;
}

strMetricFormat.defaults =
{
  divisor : 3,
  thousand : 1000,
  fixed : 1,
  dimensions : 1,
  metric : 0,
  metrics : null,
}

//

/**
 * Short-cut for strMetricFormat() function.
 * Converts number( number ) to specific count of bytes with metric prefix.
 * Example: ( 2048 -> 2.0 kb).
 *
 * @param {string|number} str - Source number to  convert.
 * @param {object} o - conversion options.
 * @param {number} [ o.divisor=3 ] - Sets count of number divisors.
 * @param {number} [ o.thousand=1024 ] - Sets integer power of one thousand.
 * @see {@link wTools.strMetricFormat} Check out main function for more usage options and details.
 * @returns {string} Returns number of bytes with metric prefix as a string.
 *
 * @example
 * //returns "100.0 b"
 * _.units.strMetricFormatBytes( 100 );
 *
 * @example
 * //returns "4.0 kb"
 * _.units.strMetricFormatBytes( 4096 );
 *
 * @example
 * //returns "1024.0 Mb"
 * _.units.strMetricFormatBytes( Math.pow( 2, 30 ) );
 *
 * @function  strMetricFormatBytes
 * @namespace Tools
 * @module Tools/base/l5/StringTools
 *
 */

function strMetricFormatBytes( number, o )
{

  o = o || Object.create( null );
  let defaultOptions =
  {
    divisor : 3,
    thousand : 1024,
  };

  _.props.supplement( o, defaultOptions );

  return _.units.strMetricFormat( number, o ) + 'b';
}

//

/**
 * Short-cut for strMetricFormat() function.
 * Converts number( number ) to specific count of seconds with metric prefix.
 * Example: ( 1000 (ms) -> 1.000 s).
 *
 * @param {number} str - Source number to  convert.
 * @param {number} [ o.fixed=3 ] - The number of digits to appear after the decimal point, example : [ '58912.001' ].
 * Can`t be changed.
 * @see {@link wTools.strMetricFormat} Check out main function for more usage options and details.
 * @returns {string} Returns number of seconds with metric prefix as a string.
 *
 * @example
 * //returns "1.000 s"
 * _.units.strTimeFormat( 1000 );
 *
 * @example
 * //returns "10.000 ks"
 * _.units.strTimeFormat( Math.pow( 10, 7 ) );
 *
 * @example
 * //returns "78.125 s"
 * _.units.strTimeFormat( Math.pow( 5, 7 ) );
 *
 * @function  strTimeFormat
 * @namespace Tools
 * @module Tools/base/l5/StringTools
 *
 */

function strTimeFormat( time )
{
  _.assert( arguments.length === 1 );
  time = _.time.from( time );
  let result = _.units.strMetricFormat( time * 0.001, { fixed : 3 } ) + 's';
  return result;
}

//

function unitsConvert_functor( fo )
{
  _.assert( arguments.length === 1 );
  _.routine.options( unitsConvert_functor, fo );
  _.assert( fo.unitsBaseRatio.default in fo.unitsBaseRatio );
  _.each( fo.unitsBaseRatio, ( e, k ) => _.assert( /[a-zA-Z]+$/.test( k ) ) );

  if( fo.metrics === null )
  fo.metrics = _metrics;

  /* */

  function unitsConvert( o )
  {
    _.assert( arguments.length === 1 );
    _.routine.options( unitsConvert, o );
    _.assert( o.dstType in fo.unitsBaseRatio );

    if( o.dstType === 'default' )
    o.dstType = fo.unitsBaseRatio[ o.dstType ];

    if( _.str.is( o.src ) )
    {
      const splits = _.strIsolateLeftOrAll( o.src, /[a-zA-Z]*$/ );
      if( splits[ 1 ] === undefined )
      {
        const multiplier = multiplierGet( o.dstType, fo.unitsBaseRatio.default );
        return multiplier * _.number.from( o.src );
      }

      let multiplier = 1;
      let type = splits[ 1 ];
      let prefix = '';
      if( !( type in fo.unitsBaseRatio ) )
      {
        prefix = type[ 0 ];
        for( let key in fo.metrics )
        if( fo.metrics[ key ].symbol === prefix )
        {
          multiplier = Math.pow( 10, _.number.from( key ) );
          type = type.substring( 1 );
          break;
        }
      }

      if( multiplier === 0.1 )
      if( prefix === 'd' && type[ 0 ] === 'a' && !( type in fo.unitsBaseRatio ) )
      {
        multiplier = 10;
        type = type.substring( 1 );
      }

      _.assert( _.number.is( multiplier ) );

      const typeMultiplier = multiplierGet( o.dstType, type );
      return multiplier * typeMultiplier * _.number.from( splits[ 0 ] );
    }
    else if( _.number.is( o.src ) )
    {
      const multiplier = multiplierGet( o.dstType, fo.unitsBaseRatio.default );
      return multiplier * o.src;
    }
    else
    {
      _.assert( false, 'Unexpected type of of {-o.src-}.' );
    }
  }

  unitsConvert.defaults =
  {
    src : null,
    dstType : 'default',
  };

  return unitsConvert;

  /* */

  function multiplierGet( dstType, baseType )
  {
    if( dstType === baseType )
    return 1;

    if( dstType === fo.unitsBaseRatio.default )
    return fo.unitsBaseRatio[ dstType ] * fo.unitsBaseRatio[ baseType ];

    return ( fo.unitsBaseRatio[ fo.unitsBaseRatio.default ] / fo.unitsBaseRatio[ dstType ] ) * fo.unitsBaseRatio[ baseType ];
  }
}

unitsConvert_functor.defaults =
{
  unitsBaseRatio : null,
  metrics : null,
};

// --
// declare
// --

let Extension =
{

  // format

  strToBytes,
  strMetricFormat,
  strMetricFormatBytes,

  strTimeFormat,

  unitsConvert_functor,
}

_.props.extend( _.units, Extension );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
