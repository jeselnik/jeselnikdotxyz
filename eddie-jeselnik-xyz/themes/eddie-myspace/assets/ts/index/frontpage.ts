/*! Check github for the un-minified code :p */
const onlineBadge = document.getElementById("onlineBadge") as HTMLImageElement;

/* tbd: add medicare #, mygov security question answers */
const birthday: Date = new Date("July 28, 2000 10:00:00");

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

async function visitorCounter(): Promise<number> {
  const visited = localStorage.getItem("visited");
  let incr = true;
  if (visited == "true") {
    incr = false;
  }

  const response = await fetch("https://dg3oo7ffiqitokznjzarauyq440cwnyc.lambda-url.ap-southeast-2.on.aws",
    {
      method: "POST",
      body: JSON.stringify({increment: incr}),
    }
  );
  if (!response.ok || response.status != 200) {
    throw new Error("Failed to fetch visitor count!");
  }

  const data = await response.json();
  localStorage.setItem("visited", "true");
  return data.totalVisitors;
}

export function main(): void {
  let env = "production";
  if (! this.location.href.includes("https://eddie.jeselnik.xyz")) {
    env = "test";
  }

  document.getElementById("agePar")!.innerHTML = whatsMyAgeAgain(birthday) + " years old";

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
