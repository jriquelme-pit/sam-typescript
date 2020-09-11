import {CustomHandler} from "../../libs";

interface ResponseProps {
  name: string
}

export type ResponseHandler = CustomHandler<ResponseProps, string>;
