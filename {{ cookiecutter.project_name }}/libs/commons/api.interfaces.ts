import {Callback, Context} from "aws-lambda";

export type CustomHandler<E extends {}, C = any> = (event: E, context: Context | null, callback: Callback<C>) => void;
