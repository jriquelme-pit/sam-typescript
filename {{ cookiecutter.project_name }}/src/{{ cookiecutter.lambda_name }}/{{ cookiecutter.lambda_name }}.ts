import {ResponseHandler} from "{{ cookiecutter.lambda_name }}.type"


export const getHello: ResponseHandler = async ({name}, context, callback) => {
      callback(null, `Hello: ${name}`);
}

