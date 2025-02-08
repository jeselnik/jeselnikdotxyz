const songs = [
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
];

/* 
  No one should take themselves so seriously
  With many years ahead to fall in line
  Why would you wish that on me?
  I never wanna act my age
*/
function whatsMyAgeAgain(bDay) {
  const dateBithday = new Date(bDay);
  const dateNow = new Date();

  let diff = dateNow.getFullYear() - dateBithday.getFullYear();
  const monthDiff = dateNow.getMonth() - dateBithday.getMonth();
  const dateDiff = dateNow.getDate() - dateBithday.getDay();

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

function buildSpotifyUrl(songID) {
  return "https://open.spotify.com/embed/track/" + songID + "?utm_source=generator";
}

function randomSpotifyTrack(songsArr) {
  var trackIndex = Math.floor(Math.random()*songsArr.length);
  return buildSpotifyUrl(songsArr[trackIndex]);
}

document.addEventListener("DOMContentLoaded", function() {
  document.getElementById("agePar").innerHTML = whatsMyAgeAgain(profile.birthday) + " years old";
  document.getElementById("location").innerHTML = profile.location;
  document.getElementById("spotifyEmbed").src = randomSpotifyTrack(songs);
  document.getElementById("spotifyEmbed").src += '';
});
