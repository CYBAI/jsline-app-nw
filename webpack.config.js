var path = require('path');
var webpack = require('webpack');
var BowerWebpackPlugin = require('bower-webpack-plugin');

var config = {
  entry: {
    app: ['./src/main.coffee']
  },
  resolve: {
    alias: {
      unirest: './node_modules/jsline-api/node_modules/unirest/index.js'
    }
  },
  output: {
    path: './build',
    filename: 'bundle.js'
  },
  module: {
    noParse: [
      /jsline-api/
    ],
    loaders: [
      { test: /\.styl$/, loader: 'style!css!stylus' },
      { test: /\.coffee$/, loader: '6to5!coffee' },
      { test: /\.css$/, loader: 'style!css' },
      { test: /\.(woff|svg|ttf|eot)([\?]?.*)$/, loader: 'file-loader?name=[name].[ext]' },
      { test: /\.vue$/, loader: '6to5!vue' },
      // { test: /\.js$/, exclude: /(node_modules|bower_components)/, loader: '6to5-loader?experimental&optional=selfContained' }
    ]
  },
  node: {},
  plugins: [
    new BowerWebpackPlugin({
      excludes: /.*\.less/
    }),
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      _: 'lodash',
      Promise: 'bluebird',
      regeneratorRuntime: 'regenerator/runtime'
    })
  ],
  target: 'node-webkit'
};

module.exports = config;
