import {CustomHandler} from "libs";

interface ResponseProps {
  name: string | any
}

export type ResponseHandler = CustomHandler<ResponseProps, string>;
