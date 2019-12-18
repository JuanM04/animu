import { NowRequest, NowResponse } from "@now/node";
import cloudscraper from "cloudscraper";

/**
 * * Required parameters
 * query
 */
export default (req: NowRequest, res: NowResponse) => {
  // XOR
  if (!(req.query.query ? !req.query.value : req.query.value)) {
    res.statusCode = 400;
    res.send({ error: "Missing parameters" });
  }

  cloudscraper
    .post({
      uri: "https://animeflv.net/api/animes/search",
      formData: { value: req.query.query || req.query.value }
    })
    .then(data => res.send(JSON.parse(data)))
    .catch(error => {
      res.statusCode = 500;
      res.send({ error });
    });
};
