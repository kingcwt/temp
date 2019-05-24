//const MinifyPlugin = require("babel-minify-webpack-plugin");
var webpack = require('webpack')
const UglifyJsPlugin = require('uglifyjs-webpack-plugin')
const path = require("path");

var fs = require('fs');

var nodeModules = {};
fs.readdirSync('node_modules')
  .filter(function(x) {
    return ['.bin'].indexOf(x) === -1;
  })
  .forEach(function(mod) {
    nodeModules[mod] = 'commonjs ' + mod;
  });

//nodeModules['nanoid/generate'] = 'commonjs nanoid'

//console.log("nodeModules:")
//console.dir(nodeModules)

const plugins = [
  new UglifyJsPlugin()
]


module.exports = {

  target: 'node',

  node: {
    __dirname: false,
    __filename: false,
  },

  mode: 'production',
  entry: './src/server.coffee',

  output: {
    path: path.join(__dirname, 'build/lib'),
    filename: 'server.min.js'
  },

  externals: nodeModules,

  module: {
    rules: [
      {
        test: /\.coffee$/,
        loader: 'coffee-loader',
        exclude: /node_modules/
      }
    ]
  },

  resolve:{
    extensions: [".coffee", ".json" , '.js'],
    alias: {
    }
  },

  //resolve: {
    //alias: {
      //'nanoid/generate' : path.resolve(__dirname, 'node_modules/nanoid/generate.js')
    //}
  //},

  plugins: plugins
}


