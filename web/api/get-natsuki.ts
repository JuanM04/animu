import { NowRequest, NowResponse } from "@now/node";
import cloudscraper from "cloudscraper";

export default (req: NowRequest, res: NowResponse) => {
  cloudscraper
    .get(req.body.replace("embed.php", "check.php"))
    .then(data => res.send(JSON.parse(data).file));
};
