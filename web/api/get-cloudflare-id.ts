import { NowRequest, NowResponse } from "@now/node";
import cloudscraper from "cloudscraper";

export default (req: NowRequest, res: NowResponse) => {
  let jar = cloudscraper.jar();

  cloudscraper({
    url: `https://animeflv.net`,
    jar: jar
  }).then(_ => {
    const cfCookie = jar
      .getCookies("https://animeflv.net")
      .find(cookie => cookie.key == "__cfduid");

    if (cfCookie == null) {
      res.statusCode = 500;
      res.send("Error");
    } else {
      res.send(cfCookie.value);
    }
  });
};
