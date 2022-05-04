
let _ = require( 'wunit' );

const unit = _.units.strMetricFormatBytes( 1024 );
console.log( unit );
/* log : 1.0 kb */
