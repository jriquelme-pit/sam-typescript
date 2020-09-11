import {ResponseHandler} from "{{ cookiecutter.first_lambda_name }}.type"


export const getHello: ResponseHandler = async ({name}, context, callback) => {
      callback(null, `Hello: ${name}`);
}

