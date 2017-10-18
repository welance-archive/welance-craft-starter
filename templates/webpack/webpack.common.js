const webpack = require("webpack");
const path = require('path');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');

let BASE_URL  = '/';                          //HTML5 history api href for <base>
let API_URL   = 'http://localhost/';     //API endpoints base

const mainJSPath = path.resolve(__dirname, '../__src/js', 'main.js');
const mainCSSPath = path.resolve(__dirname, '../__src/sass', 'main.scss');
const publicPath = path.resolve(__dirname, '../../public/assets');
const imagesPath = path.resolve(__dirname, '../__src/images');
const fontsPath = path.resolve(__dirname, '../__src/fonts');

switch(process.env.NODE_ENV){
  case 'dev':
    BASE_URL = '/';
    API_URL  = 'http://localhost/';
    break;
  case 'prod':
    BASE_URL = '/';
    API_URL = 'http://localhost/';
    break;
  // case 'gh-pages':
  //   BASE_URL = '/repo-name/';
  //   API_URL = 'https://welance.github.io/repo-name/'
  //   break;
  default:
    //nothing here;
    break;
}

module.exports = {
  entry: {
    main: [
      mainJSPath,
      mainCSSPath
    ],
    vendor: ["jquery", "object-fit-images"]
  },
  output: {
    filename: process.env.NODE_ENV === 'prod' ? 'scripts/[name].min.js?h=[hash]' : 'scripts/[name].js?h=[hash]',
    path: publicPath,
    publicPath: '/assets/'
  },
  plugins: [
    new webpack.DefinePlugin({
      "BASE_URL": JSON.stringify(BASE_URL),
      "API_URL": JSON.stringify(API_URL)
    }),
    new CleanWebpackPlugin(['../../public/assets']),
    // Simply copy assets to dist folder
    new CopyWebpackPlugin([
      { from: imagesPath, to: 'images' },
      { from: fontsPath, to: 'fonts' }
    ]),
    new HtmlWebpackPlugin({
      template: '../templates/_includes/_layouts/base.html',
      filename: '../../templates/_includes/_layouts/webpack_base.html',
      hash: true,
      inject: true
    })
  ],
  resolve: {
		alias: {
      // styles:  path.resolve(__dirname, '../src/sass'), // relative to the location of the webpack config file!
			// node_modules: path.resolve(__dirname, 'node_modules'),
      // components: path.resolve(__dirname, 'src/components')
		}
	},
  module: {
		rules: [
			//ES2015 to ES5 compilation
			{
				test: /\.js$/,
				exclude: /node_modules/,
				use: "babel-loader"
			},
			//SASS compilation
			{
				test: /\.scss$/,
				use: ExtractTextPlugin.extract({
					fallback: "style-loader",
					use: ["css-loader", "sass-loader"],
					publicPath: "/public",
				})
			},
      {
      // Post-CSS
      test: /\.css/,
      use: [
          {
          loader: 'postcss-loader',
              options: {
                  plugins: function () {
                      return [
                          require('precss'),
                          require('autoprefixer'),
                          require('cssnano')
                      ];
                  }
              }
          }]
      }
		]
	}
};
