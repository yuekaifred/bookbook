// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

document.addEventListener("turbo:load", function () {
  const K = 32;

  function eloDeltas(winnerElo, loserElo) {
    const expected = 1 / (1 + Math.pow(10, (loserElo - winnerElo) / 400));
    const winDelta = Math.round(K * (1 - expected));
    const loseDelta = Math.round(K * (0 - (1 - expected)));
    return { winDelta, loseDelta };
  }

  function animateCount(el, targetVal, duration) {
    const startTime = performance.now();
    const prefix = targetVal > 0 ? "+" : "";
    function tick(now) {
      const progress = Math.min((now - startTime) / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 3);
      el.textContent = prefix + Math.round(targetVal * eased);
      if (progress < 1) requestAnimationFrame(tick);
    }
    requestAnimationFrame(tick);
  }

  let voted = false;

  document.querySelectorAll(".choice").forEach((btn) => {
    btn.addEventListener("click", function (e) {
      e.preventDefault();
      if (voted) return;
      voted = true;

      const form = this.closest("form");
      const allBtns = Array.from(document.querySelectorAll(".choice"));
      const otherBtn = allBtns.find((b) => b !== this);

      const myElo = parseInt(this.dataset.elo);
      const oppElo = parseInt(this.dataset.opponentElo);
      const { winDelta, loseDelta } = eloDeltas(myElo, oppElo);

      this.classList.add("chosen");
      this.querySelector(".elo-score").textContent = myElo + winDelta;
      const winDeltaEl = this.querySelector(".elo-delta");
      winDeltaEl.classList.add("positive");
      animateCount(winDeltaEl, winDelta, 700);

      otherBtn.classList.add("unchosen");
      otherBtn.querySelector(".elo-score").textContent = oppElo + loseDelta;
      const loseDeltaEl = otherBtn.querySelector(".elo-delta");
      loseDeltaEl.classList.add("negative");
      animateCount(loseDeltaEl, loseDelta, 700);

      setTimeout(
        () => document.querySelector(".compare").classList.add("fade-out"),
        650,
      );
      setTimeout(() => form.submit(), 900);
    });
  });
});
