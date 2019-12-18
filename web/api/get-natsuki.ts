import { NowRequest, NowResponse } from "@now/node";
import cloudscraper from "cloudscraper";

/**
 * * Required parameters
 * url
 */
export default (req: NowRequest, res: NowResponse) => {
  if (!req.query.url || typeof req.query.url != "string") {
    res.statusCode = 400;
    res.send({ error: "Missing parameters" });
    return;
  }

  cloudscraper
    .get(req.query.url.replace("embed.php", "check.php"))
    .then(data => {
      res.send(JSON.parse(data));
    })
    .catch(error => {
      res.statusCode = 500;
      res.send({ error });
    });
};
