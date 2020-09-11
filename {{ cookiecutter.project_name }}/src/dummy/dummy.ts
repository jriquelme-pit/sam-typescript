import {ResponseHandler} from "./dummy.types"


export const getHello: ResponseHandler = async ({}, context, callback) => {
      callback(null, `Hello: word`);
}

