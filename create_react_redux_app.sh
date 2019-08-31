#!/usr/bin/env bash
set -e

createDir() {
    echo "Creating directory : $1"
    mkdir $1
    cd $1 && mkdir src && cd src
    touch index.html
    touch index.js
    touch App.jsx
    touch store.js
    mkdir -p actions
    mkdir -p reducers
    mkdir -p components
    mkdir -p configs
    printf "import axios from 'axios';\nconst axiosInstance = axios.create();\nexport default axiosInstance;\n" >> configs/axios.js
    cd ../
    touch .babelrc
    touch webpack.common.js
    touch webpack.dev.js
    touch webpack.prod.js
}

open_project_in_vs_code() {
    read -p "Would you like to open the project in VS code(make sure it is installed)[y/N]" mayNotOpen
    if [[ "$mayNotOpen" = "" ]]; then
        return 1
    elif [[ "$mayNotOpen" = "y" ]]; then
        echo "Opening project in VS code..."
        code .
    fi
}

install() {
	git init
	# create directory if not present
    if [[ ! -d "$1" ]]; then
    	cd ../
        createDir "$1"
    fi

    echo "Creating new React app.."
    npm init

    printf "Installing dev dependencies...\n"
    echo "Installing Webapack..."
    npm install --save-dev webpack webpack-cli webpack-dev-server

    echo "Installing Webpack plugins..."
    npm install --save-dev html-webpack-plugin clean-webpack-plugin uglifyjs-webpack-plugin mini-css-extract-plugin lodash-webpack-plugin optimize-css-assets-webpack-plugin terser-webpack-plugin webpack-merge

    echo "Installing Babel and presets..."
    npm install --save-dev babel-core babel-loader babel-preset-env babel-preset-react babel-plugin-transform-class-properties  babel-plugin-transform-object-rest-spread babel-preset-stage-2 babel-plugin-lodash

    echo "Installing Webpack loaders..."
    npm install --save-dev css-loader sass-loader node-sass file-loader style-loader
    
    echo "Installing core Dependencies..."
    echo "Installing React"
    npm install --save react react-dom react-router-dom axios prop-types
    
    echo "Installing Redux..."
    npm install --save redux react-redux redux-thunk

    echo "node_modules" >> .gitignore

    printf "All done...\n Happy coding \u2764\n"
    open_project_in_vs_code
}


uninstall() {
    read -p "Are you sure want to uninstall? this will delete your directory in local. You may manually have to delete in your remote repository. [y/N]" mayBeDanger

    if [[ "$mayBeDanger" = "" ]]; then
        return 1
    elif [[ "$mayBeDanger" = "y" ]]; then
        echo "Deleting app ..."
        sudo rm -rf $1
    fi
}

showMessage() {
printf "Usage: ./create_react_redux_app.sh <COMMAND> <DIRECTORY>\n"
printf "\nwhere <COMMAND> is one of: \n install \n uninstall\n\n<DIRECTORY> is name of your app directory\n"
return 0
}

if [[ -z "$1" ]];then
    showMessage
elif [[ -z "$2" ]]; then
    showMessage
else
    case $1 in
    "install")
    install "$2"
    ;;
    "uninstall")
    uninstall "$2"
    ;;
    *)
    echo "Skipping..."
    ;;
    esac
fi

