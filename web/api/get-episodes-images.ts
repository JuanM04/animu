import { NowRequest, NowResponse } from "@now/node";
import cloudscraper from "cloudscraper";

export default (req: NowRequest, res: NowResponse) => {
  const data = req.body;

  async function getBase64(episode) {
    let img = await cloudscraper({
      url: `https://cdn.animeflv.net/screenshots/${data.animeId}/${episode.n}/th_3.jpg`,
      method: "GET",
      encoding: null
    });

    return {
      ...episode,
      thumbnail: Buffer.from(img).toString("base64")
    };
  }

  let episodesWithImages = data.episodes.map(getBase64);

  Promise.all(episodesWithImages).then(res.send);
};
