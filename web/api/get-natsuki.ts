import { NowRequest, NowResponse } from "@now/node";
import cloudscraper from "cloudscraper";

export default (req: NowRequest, res: NowResponse) => {
  cloudscraper
    .get(req.body.replaceFirst("embed.php", "check.php"))
    .then(res => res.send(res.data));
};
