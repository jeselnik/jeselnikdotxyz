/*! Check github for the un-minified code :p */

const onlineBadge = document.getElementById("onlineBadge") as HTMLImageElement;
const spotifyEmbed = document.getElementById("musicBox") as HTMLIFrameElement;

/* tbd: add medicare #, mygov security question answers */
const birthday: Date = new Date("July 28, 2000 10:00:00");

const songs: Array<string> = [
  /* nurnberg - valasy */
  '0me5bs5Ww1boCUR4tdcbXd',
  /* blink 182 - what's my age again */
  '4LJhJ6DQS7NwE7UKtvcM52',
  /* isheika - kogda my umiraem */
  '58noIDh7ilKCIOThwyTqKH',
  /* blink 182 - adam's song */
  '6xpDh0dXrkVp0Po1qrHUd8',
  /* paramore - when it rains */
  '5MNsy8G3K0Y09QFpktzyrj',
  /* all american rejects - swing, swing */
  '003FTlCpBTM4eSqYSWPv4H',
  /* avril lavigne - sk8er boi
    not a massive fan but eh, it's on theme */
  '00Mb3DuaIH1kjrwOku9CGU',
  /* mcr - famous last words */
  '2d6m2F4I7wCuAKtSsdhh83',
  /* molchat doma - son */
  '6bn5OFUhl8lm4VzKEPSzEz',
  /* all american rejects - it ends tonight */
  '5ZqNz8GXWpkb95f7aVxTA0',
  /* magdalena bay - you lose! */
  '0tP8FKhJsar5y4JcOH4Rjp',
  /* depeche mode - enjoy the silence */
  '0yp3TvJNlG50Q4tAHWNCRm',
  /* soulja boy - crank that */
  '66TRwr5uJwPt15mfFkzhbi',
  /* soulja boy - kiss me thru the phone */
  '2q4rjDy9WhaN3o9MvDbO21',
];

/* 
  No one should take themselves so seriously
  With many years ahead to fall in line
  Why would you wish that on me?
  I never wanna act my age
*/
function whatsMyAgeAgain(bDay: Date): number {
  const dateNow: Date = new Date();

  let diff: number = dateNow.getFullYear() - bDay.getFullYear();
  const monthDiff: number = dateNow.getMonth() - bDay.getMonth();
  const dateDiff: number = dateNow.getDate() - bDay.getDay();

  if (
    monthDiff < 0 ||
    (monthDiff === 0 && dateDiff < 0)
  ) {
    diff--;
  }

  if (diff === 23) {
    console.log("nobody likes you when you're 23.");
  }

  return diff;
}

function buildSpotifyUrl(songID: string): string {
  return "https://open.spotify.com/embed/track/" + songID + "?utm_source=generator";
}

function randomSpotifyTrack(songsArr: Array<string>): string {
  var trackIndex = Math.floor(Math.random()*songsArr.length);
  return buildSpotifyUrl(songsArr[trackIndex]);
}

async function visitorCounter(): Promise<number> {
  const response = await fetch("https://dg3oo7ffiqitokznjzarauyq440cwnyc.lambda-url.ap-southeast-2.on.aws");
  if (!response.ok) {
    throw new Error("Failed to fetch visitor count!");
  }

  const data = await response.json();
  return data.totalVisitors;
}

function main(): void {
  let env = "production";
  if (! this.location.href.includes("https://eddie.jeselnik.xyz")) {
    env = "test";
  }

  document.getElementById("agePar")!.innerHTML = whatsMyAgeAgain(birthday) + " years old";
  spotifyEmbed.src = randomSpotifyTrack(songs);
  spotifyEmbed.src += '';

  onlineBadge.addEventListener("mouseover", () => {
    onlineBadge.src="/assets/badges/70.gif";
  })

  onlineBadge.addEventListener("mouseout", () => {
    onlineBadge.src="/assets/badges/online.gif";
  })

  if (env !== "production") {
    return
  }

  visitorCounter()
    .then(data => {
      document.getElementById("visitorCount")!.innerHTML = "<b>Profile Views:</b> " + data;
    })
    .catch(error => {
      console.error(error.message);
    });
}

main();
