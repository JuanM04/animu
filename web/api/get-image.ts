import { NowRequest, NowResponse } from "@now/node";
import cloudscraper from "cloudscraper";

/**
 * * Required parameters
 * anime_id
 * anime_slug
 */
export default (req: NowRequest, res: NowResponse) => {
  if (
    !req.query.type ||
    !req.query.anime_id ||
    (req.query.type == "thumbnail" && !req.query.episode_n)
  ) {
    res.statusCode = 400;
    res.send({ error: "Missing parameters" });
  }

  cloudscraper
    .get(
      req.query.type == "cover"
        ? `https://animeflv.net/uploads/animes/covers/${req.query.anime_id}.jpg`
        : `https://cdn.animeflv.net/screenshots/${req.query.anime_id}/${req.query.episode_n}/th_3.jpg`,
      {
        encoding: null
      }
    )
    .then(data => {
      res.setHeader("content-type", "image/jpeg");
      res.send(data);
    })
    .catch(error => {
      res.statusCode = 500;
      res.send({ error });
    });
};
