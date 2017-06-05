// JS from vendors from node_modules (installed with NPM)
import $ from 'jquery';
import objectFitImages from 'object-fit-images';
//import whateverOtherJqueryPlugin from 'whateverJqueryPlugin';

// template-specific JS
import './plugins/wc-accordion.js';

// template-specific JS for entries
import '../../_entries/pages/page.js';
import '../../_entries/posts/post.js';

$(function() {
    //init all accordions
    $('.wc-accordion').wc_accordion();

    console.info( "Good News: Jquery is ready in jqueryReady!" );
});

console.info("Good News: Main.js file has been imported!");
