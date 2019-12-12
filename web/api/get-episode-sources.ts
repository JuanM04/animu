import { NowRequest, NowResponse } from "@now/node";
import cloudscraper from "cloudscraper";

/**
 * * Required parameters
 * anime_slug
 * episode_id
 * episode_n
 */
export default (req: NowRequest, res: NowResponse) => {
  if (!req.query.episode_id || !req.query.anime_slug || !req.query.episode_n) {
    res.statusCode = 400;
    res.send({ error: "Missing parameters" });
  }

  cloudscraper
    .get(
      `https://animeflv.net/ver/${req.query.episode_id}/${req.query.anime_slug}-${req.query.episode_n}`
    )
    .then(data => {
      const rawSources = data.split("var videos = ", 2)[1].split(";", 2)[0];
      res.send(JSON.parse(rawSources).SUB);
    })
    .catch(error => {
      res.statusCode = 500;
      res.send({ error });
    });
};
