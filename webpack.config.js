let webpack = require("webpack");
let ExtractTextPlugin = require('extract-text-webpack-plugin');
let path = require('path');
let CopyWebpackPlugin = require('copy-webpack-plugin');
let ImageminWebpackPlugin = require('imagemin-webpack-plugin').default;
let FaviconsWebpackPlugin = require('favicons-webpack-plugin');

const mainJSPath = path.resolve(__dirname, '__src/js', 'main.js');
const mainCSSPath = path.resolve(__dirname, '__src/sass', 'main.scss');
const publicPath = path.resolve(__dirname, '../../public/assets');

const prod_plugins = [
		//about SASS compilation
		new ExtractTextPlugin({
			filename: "styles/main.min.css"
		}),
		// Copy the images folder and optimize all the images
		new CopyWebpackPlugin([{
			from: './__src/images/',
			to: '../../public/assets/images/'
		}]),
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
			logo: './__src/images/favicon.svg',
			// The prefix for all image files (might be a folder or a name)
			prefix: '../../public/assets/images/icons-[hash]/',
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
		})
	];


const dev_plugins = [
		//about HTML compression and CSS/JS scripts injection
		// [TODO?]
		//about SASS compilation
		new ExtractTextPlugin({
			filename: "styles/main.css"
		}),
		// Copy the images folder and optimize all the images
		new CopyWebpackPlugin([{
			from: './__src/images/',
			to: '../../public/assets/images/'
		}]),
		new FaviconsWebpackPlugin({
			// Your source logo
			logo: './__src/images/favicon.svg',
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
		})
	];

const plugins = process.env.NODE_ENV === 'prod' ? prod_plugins : dev_plugins;



module.exports = {
	entry: {
     main: [
      'babel-polyfill',
      mainJSPath,
      mainCSSPath
    ]
  },
  output: {
    filename: process.env.NODE_ENV === 'prod' ? path.join('scripts','[name].min.js') : path.join('scripts','[name].js'),
    path: publicPath,
    publicPath: publicPath
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
