module.exports = function(__obj) {
  if (!__obj) __obj = {};
  var __out = [], __capture = function(callback) {
    var out = __out, result;
    __out = [];
    callback.call(this);
    result = __out.join('');
    __out = out;
    return __safe(result);
  }, __sanitize = function(value) {
    if (value && value.ecoSafe) {
      return value;
    } else if (typeof value !== 'undefined' && value != null) {
      return __escape(value);
    } else {
      return '';
    }
  }, __safe, __objSafe = __obj.safe, __escape = __obj.escape;
  __safe = __obj.safe = function(value) {
    if (value && value.ecoSafe) {
      return value;
    } else {
      if (!(typeof value !== 'undefined' && value != null)) value = '';
      var result = new String(value);
      result.ecoSafe = true;
      return result;
    }
  };
  if (!__escape) {
    __escape = __obj.escape = function(value) {
      return ('' + value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
    };
  }
  (function() {
    (function() {
      var key, _i, _len, _ref;
    
      if (this.subject) {
        __out.push('\n<ul>\n  <li>id: ');
        __out.push(this.subject.zooniverse_id);
        __out.push('</li>\n  ');
        if (this.subject.image.src) {
          __out.push('\n  <li><img src="');
          __out.push(this.subject.image.src);
          __out.push('" /></li>\n  ');
        }
        __out.push('\n  ');
        _ref = this.keys;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          key = _ref[_i];
          __out.push('\n  <li>');
          __out.push(key);
          __out.push(': ');
          __out.push(this.subject[key]);
          __out.push('</li>\n  ');
        }
        __out.push('\n</ul>\n');
      }
    
      __out.push('\n<a class="next">next</a>\n<a class="back">back</a>\n');
    
    }).call(this);
    
  }).call(__obj);
  __obj.safe = __objSafe, __obj.escape = __escape;
  return __out.join('');
}