const spotifyEmbed = document.getElementById("musicBox") as HTMLIFrameElement;

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

function buildSpotifyUrl(songID: string): string {
  return "https://open.spotify.com/embed/track/" + songID + "?utm_source=generator";
}

function randomSpotifyTrack(songsArr: Array<string>): string {
  var trackIndex = Math.floor(Math.random()*songsArr.length);
  return buildSpotifyUrl(songsArr[trackIndex]);
}

export function setTrack(): void {
  spotifyEmbed.src = randomSpotifyTrack(songs);
  spotifyEmbed.src += '';
}
