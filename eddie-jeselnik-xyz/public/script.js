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

document.addEventListener("DOMContentLoaded", function() {
  document.getElementById("agePar").innerHTML = whatsMyAgeAgain(profile.birthday) + " years old";
  document.getElementById("location").innerHTML = profile.location;
});
