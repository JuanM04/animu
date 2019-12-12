import { NowRequest, NowResponse } from "@now/node";
import cloudscraper from "cloudscraper";

/**
 * * Required parameters
 * anime_id
 * anime_slug
 */
export default (req: NowRequest, res: NowResponse) => {
  if (!req.query.anime_id || !req.query.anime_slug) {
    res.statusCode = 400;
    res.send({ error: "Missing parameters" });
  }

  cloudscraper
    .get(
      `https://animeflv.net/anime/${req.query.anime_id}/${req.query.anime_slug}`
    )
    .then(data => {
      const rawSources = data.split("var episodes = ", 2)[1].split(";", 2)[0];
      res.send(JSON.parse(rawSources));
    })
    .catch(error => {
      res.statusCode = 500;
      res.send({ error });
    });
};
