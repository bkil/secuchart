# Jericho Comms secure group chat program using one-time pads

https://joshua-m-david.github.io/jerichoencryption/index.html

> Any one who considers arithmetical methods of producing random digits is, of course, in a state of sin - John von Neumann

I see that it uses file image data or freshly taken pictures as its source of random numbers:

- https://github.com/joshua-m-david/jerichoencryption/blob/master/client/scripts/pages/trng.js#L180
- https://github.com/joshua-m-david/jerichoencryption/blob/master/client/scripts/pages/trng-capture.js#L56

This uses the underlying thermal noise of a CMOS sensor, however its weakness lies in that it does not account for biases due to defects in the sensor or dust, and an even bigger issue is image enhancement artifacts introduced by post processing of the camera driver or firmware and that the demosaicing algorithms themselves introduce elaborate correlation within the bits (i.e, to interpolate the missing information).

- https://en.wikipedia.org/wiki/Demosaicing

It falls back to Salsa20 on failure:

- https://github.com/joshua-m-david/jerichoencryption/blob/master/client/scripts/csprng.js

After scrolling through the source, I say that it is mostly well engineered. However, it contains tens of thousands of lines of code and additional external algorithms. Reviewing that is not implausible for a dedicated researcher given a weekend, but this would not be sufficient for a careful review. Doing that would be awkward because its test coverage and modularization is not that great in that aspect. And based on the sheer number of lines, I would bet that it has quite a number of technical flaws.

And then it also misses the opportunity to use more modern technologies (like Haxe, TypeScript and SCSS).

Overall, this project also just reiterates what we know of OTP vs. stretching based encryption: OTP is theoretically superior, but managing and communicating the huge key material itself is awkward _(all the extra chores to authenticate the key material in the database is just unproductive for example)_. Compare this to just a few lines of code to use the Web Crypto API or some other well known built-in encryption primitive:

- https://developer.mozilla.org/en-US/docs/Web/API/Web_Crypto_API
- https://www.php.net/manual/en/function.openssl-encrypt.php
