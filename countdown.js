const deadline = 'July 1 2021 00:00:00 GMT+0800';

function getTimeRemaining(endtime){
  const total = Date.parse(endtime) - Date.parse(new Date());
  const days = Math.floor( total/86400000+1 );

  return {
    total,
    days
  };
}
function initializeClock(endtime) {
  const day = document.getElementById('day');
  function updateClock(){
    const t = getTimeRemaining(endtime);
    day.innerHTML = t.days;
    if (t.total <= 0) {
      clearInterval(timeinterval);
    }
  }
  updateClock();
  var timeinterval = setInterval(updateClock,1000);
}
initializeClock(deadline);
