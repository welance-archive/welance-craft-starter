const webpack = require("webpack");
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const ImageminWebpackPlugin = require('imagemin-webpack-plugin').default;
const FaviconsWebpackPlugin = require('favicons-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');

const mainJSPath = path.resolve(__dirname, '__src/js', 'main.js');
const mainCSSPath = path.resolve(__dirname, '__src/sass', 'main.scss');
const publicPath = path.resolve(__dirname, '../public/assets');
const imagesPath = path.resolve(__dirname, '__src/images');
const rootPath = path.resolve(__dirname);

const prod_plugins = [
		//about SASS compilation
		new ExtractTextPlugin({
			filename: "styles/main.min.css"
		}),
		// Copy the images folder and optimize all the images
		new CopyWebpackPlugin([
      { from: imagesPath + '/', to: 'images' }, { from: './__src/fonts/', to: 'fonts' }
    ]),
		new ImageminWebpackPlugin({
			test: /\.(jpe?g|png|gif|svg)$/i,
			//disable: process.env.NODE_ENV !== 'prod',
			pngquant: {
				quality: '95-100'
			},
			optipng: {
				optimizationLevel: 5 //0-7 (7 slower)
			},
			jpegtran: {
				progressive: true
			},
			gifsicle: {
				optimizationLevel: 3 //1-3 (3 slower)
			}
		}),
		new FaviconsWebpackPlugin({
			// Your source logo
			logo: imagesPath + '/favicon.png',
			// The prefix for all image files (might be a folder or a name)
			prefix: 'images/icons-[hash]/',
			// Emit all stats of the generated icons
			emitStats: false,
			// The name of the json containing all favicon information
			statsFilename: 'iconstats-[hash].json',
			// Generate a cache file with control hashes and
			// don't rebuild the favicons until those hashes change
			persistentCache: true,
			// Inject the html into the html-webpack-plugin
			inject: true,
			// favicon background color (see https://github.com/haydenbleasel/favicons#usage)
			//background: '#fff',
			// favicon app title (see https://github.com/haydenbleasel/favicons#usage)
			title: 'Welance Website',

			// which icons should be generated (see https://github.com/haydenbleasel/favicons#usage)
			icons: {
				android: true,
				appleIcon: true,
				appleStartup: true,
				coast: false,
				favicons: true,
				firefox: true,
				opengraph: false,
				twitter: false,
				yandex: false,
				windows: false
			}
		}),
    new HtmlWebpackPlugin({
      template: '_includes/_layouts/base.html',
      filename: rootPath + '/_includes/_layouts/webpack_base.html',
      hash: true,
      inject: true
    }),
    new webpack.optimize.CommonsChunkPlugin({ name: 'vendor', filename: 'scripts/vendor.min.js?h=[hash]' })
	];


const dev_plugins = [
		//about HTML compression and CSS/JS scripts injection
		// [TODO?]
		//about SASS compilation
		new ExtractTextPlugin({
			filename: "styles/main.css"
		}),
		// Copy the images folder and optimize all the images
		new CopyWebpackPlugin([
      { from: imagesPath + '/', to: 'images' }, { from: './__src/fonts/', to: 'fonts' }
    ]),
		new FaviconsWebpackPlugin({
			// Your source logo
			logo: imagesPath + '/favicon.png',
			// The prefix for all image files (might be a folder or a name)
			prefix: 'images/icons-[hash]/',
			// Emit all stats of the generated icons
			emitStats: false,
			// The name of the json containing all favicon information
			statsFilename: 'iconstats-[hash].json',
			// Generate a cache file with control hashes and
			// don't rebuild the favicons until those hashes change
			persistentCache: true,
			// Inject the html into the html-webpack-plugin
			inject: true,
			// favicon background color (see https://github.com/haydenbleasel/favicons#usage)
			// favicon app title (see https://github.com/haydenbleasel/favicons#usage)
			title: 'Welance Website',

			// which icons should be generated (see https://github.com/haydenbleasel/favicons#usage)
			icons: {
				android: false,
				appleIcon: false,
				appleStartup: false,
				coast: false,
				favicons: true,
				firefox: false,
				opengraph: false,
				twitter: false,
				yandex: false,
				windows: false
			}
		}),
    new HtmlWebpackPlugin({
      template: '_includes/_layouts/base.html',
      filename: rootPath + '/_includes/_layouts/webpack_base.html',
      hash: true,
      inject: true
    })
	];

const plugins = process.env.NODE_ENV === 'prod' ? prod_plugins : dev_plugins;



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
	},
	plugins: plugins
};
