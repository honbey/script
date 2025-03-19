'use strict'
let input = document.querySelector('[name="input"]');
let output = document.querySelector('[name="output"]');

const single = document.querySelector('[name="single"]');
const double = document.querySelector('[name="double"]');

single.onclick = () => {
  output.parentElement.style.display = 'none';
  output = document.querySelector('[name="input"]');
  input.parentElement.className = 'column is-full';
  double.checked = false;
  single.checked = true;
}
double.onclick = () => {
  output = document.querySelector('[name="output"]');
  output.parentElement.style.display = 'block';
  input.parentElement.className = 'column';
  double.checked = true;
  single.checked = false;
}

/* URL */
document.querySelector('[title="URL Encode"]').onclick = () => {
  let src = input.value;
  output.value = encodeURIComponent(src);
}
document.querySelector('[title="URL Decode"]').onclick = () => {
  let src = input.value;
  output.value = decodeURIComponent(src);
}

/* HTML */
document.querySelector('[title="HTML Encode"]').onclick = () => {
  let src = input.value;
  let div = document.createElement('div');
  (div.textContent != undefined) ? (div.textContent = src) : (div.innerText = src);
  output.value = div.innerHTML;
}
document.querySelector('[title="HTML Decode"]').onclick = () => {
  let src = input.value;
  let div = document.createElement('div');
  div.innerHTML = src;
  output.value = div.textContent || div.innerText;
}

/* BASE64 */
document.querySelector('[title="BASE64 Encode"]').onclick = () => {
  let src = input.value;
  let utf8Str = unescape(encodeURIComponent(src))
  output.value = btoa(utf8Str);
}
document.querySelector('[title="BASE64 Decode"]').onclick = () => {
  let src = input.value;
  try {
    let utf8Str = atob(src)
    output.value = decodeURIComponent(escape(utf8Str));
  } catch (e) {
    console.log(e.name + ': ' + e.message);
    // alert('Please enter an encoded string!');
    output.value = 'Please enter an encoded string!';
  }
}

/* UTF-8 */
document.querySelector('[title="To UTF-8"]').onclick = () => {
  let src = input.value;
  output.value = src.replace(/[^\u0000-\u00FF]/g, function (m) {
    return escape(m).replace(/(%u)(\w{4})/gi, "&#x$2;")
  });
}
document.querySelector('[title="From UTF-8"]').onclick = () => {
  let src = input.value;
  output.value = unescape(src.replace(/&#x/g, '%u').replace(/;/g, ''));
}

/* Unicode */
document.querySelector('[title="To Unicode"]').onclick = () => {
  let src = input.value;
  let dst = '';
  for (let i = 0; i < src.length; i++)
    dst += '&#' + src.charCodeAt(i) + ';';
  output.value = dst;
}
document.querySelector('[title="From Unicode"]').onclick = () => {
  let src = input.value.match(/&#(\d+);/g);
  let dst = '';
  for (let i = 0; i < src.length; i++)
    dst += String.fromCharCode(src[i].replace(/[&#;]/g, ''));
  output.value = dst;
}

/* ASCII */
document.querySelector('[title="To ASCII"]').onclick = () => {
  let src = input.value.split("");
  let dst = "";
  for (let i = 0; i < src.length; i++) {
    let code = Number(src[i].charCodeAt(0));
    // ignoreLetter
    if (true || code > 127) {
      let charAscii = code.toString(16);
      charAscii = new String("0000").substring(charAscii.length, 4) + charAscii;
      dst += "\\u" + charAscii;
    } else {
      dst += src[i];
    }
  }
  output.value = dst;
}
document.querySelector('[title="From ASCII"]').onclick = () => {
  let src = input.value.split("\\u");
  let dst = src[0];
  for (let i = 1; i < src.length; i++) {
    let code = src[i];
    dst += String.fromCharCode(parseInt("0x" + code.substring(0, 4)));
    if (code.length > 4) {
      dst += code.substring(4, code.length);
    }
  }
  output.value = dst;
}
