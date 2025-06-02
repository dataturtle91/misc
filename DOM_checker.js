
// Określ głębokość DOM

function getDomDepth(el = document.body) {
  if (!el.children || el.children.length === 0) return 1;
  return 1 + Math.max(...Array.from(el.children).map(getDomDepth));
}
getDomDepth();

// Określ liczbę elementów DOM

document.getElementsByTagName('*').length



/* 

Liczba elementów DOM	Ocena
< 1000 - dobra
1000–2000	-  średnia (ok)
2000–4000	- potencjalny problem
> 4000	- duży DOM bloat


Głębokość zagnieżdżenia

Głębokość DOM	Ocena
5–10	- standard
11–15	- zaawansowana struktura
>15	-  głęboka i potencjalnie problematyczna

*/ 


