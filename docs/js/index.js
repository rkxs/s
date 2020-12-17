$(function () {
  playAudio();
  //各个楼层的位置
  var lists = [
    {flag: true, top: 0}
  ];
  var index = 0, flag = true, rends = false;
  !function () {
    var canvas = document.getElementById('canvaszz'),
      ctx = canvas.getContext('2d'),
      w = canvas.width = window.innerWidth,
      h = canvas.height = window.innerHeight,
      hue = 217,
      stars = [],
      count = 0,
      maxStars = 1300;//星星数量
    var canvas2 = document.createElement('canvas'),
      ctx2 = canvas2.getContext('2d');
    canvas2.width = 100;
    canvas2.height = 100;
    var half = canvas2.width / 2,
      gradient2 = ctx2.createRadialGradient(half, half, 0, half, half, half);
    gradient2.addColorStop(0.025, '#CCC');
    gradient2.addColorStop(0.1, 'hsl(' + hue + ', 61%, 33%)');
    gradient2.addColorStop(0.25, 'hsl(' + hue + ', 64%, 6%)');
    gradient2.addColorStop(1, 'transparent');

    ctx2.fillStyle = gradient2;
    ctx2.beginPath();
    ctx2.arc(half, half, half, 0, Math.PI * 2);
    ctx2.fill();

// End cache

    function random(min, max) {
      if (arguments.length < 2) {
        max = min;
        min = 0;
      }

      if (min > max) {
        var hold = max;
        max = min;
        min = hold;
      }

      return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    function maxOrbit(x, y) {
      var max = Math.max(x, y),
        diameter = Math.round(Math.sqrt(max * max + max * max));
      return diameter / 2;
      //星星移动范围，值越大范围越小，
    }

    var Star = function () {

      this.orbitRadius = random(maxOrbit(w, h));
      this.radius = random(60, this.orbitRadius) / 8;
      //星星大小
      this.orbitX = w / 2;
      this.orbitY = h / 2;
      this.timePassed = random(0, maxStars);
      this.speed = random(this.orbitRadius) / 50000;
      //星星移动速度
      this.alpha = random(2, 10) / 10;

      count++;
      stars[count] = this;
    };

    Star.prototype.draw = function () {
      var x = Math.sin(this.timePassed) * this.orbitRadius + this.orbitX,
        y = Math.cos(this.timePassed) * this.orbitRadius + this.orbitY,
        twinkle = random(10);

      if (twinkle === 1 && this.alpha > 0) {
        this.alpha -= 0.05;
      } else if (twinkle === 2 && this.alpha < 1) {
        this.alpha += 0.05;
      }

      ctx.globalAlpha = this.alpha;
      ctx.drawImage(canvas2, x - this.radius / 2, y - this.radius / 2, this.radius, this.radius);
      this.timePassed += this.speed;
    };

    for (var i = 0; i < maxStars; i++) {
      new Star();
    }

    function animation() {
      ctx.globalCompositeOperation = 'source-over';
      ctx.globalAlpha = 0.5; //尾巴
      ctx.fillStyle = 'hsla(' + hue + ', 64%, 6%, 2)';
      ctx.fillRect(0, 0, w, h);

      ctx.globalCompositeOperation = 'lighter';
      for (var i = 1, l = stars.length; i < l; i++) {
        stars[i].draw();
      }
      ;

      window.requestAnimationFrame(animation);
    }

    animation();
  }();
  !function () {
    /* $("img").error(function () {
         $(this).attr(src,$(this).attr("src"));
     })*/
    $('.loding_box').width($(window).width());
    $('.loding_box').height($(window).height());
    var canvas = document.getElementById('lodings');
    var ctx = canvas.getContext('2d');
//range控件信息
    var rangeValue = 0;
    var nowRange = 0;   //用于做一个临时的range
//画布属性
    var mW = canvas.width = 250;
    var mH = canvas.height = 250;
    var lineWidth = 2;
//圆属性
    var r = mH / 2; //圆心
    var cR = r - 16 * lineWidth; //圆半径
//Sin 曲线属性
    var sX = 0;
    var sY = mH / 2;
    var axisLength = mW; //轴长
    var waveWidth = 0.015;   //波浪宽度,数越小越宽
    var waveHeight = 6; //波浪高度,数越大越高
    var speed = 0.09; //波浪速度，数越大速度越快
    var xOffset = 0; //波浪x偏移量
    ctx.lineWidth = lineWidth;
//画圈函数
    var IsdrawCircled = false;
    var drawCircle = function () {

      ctx.beginPath();
      ctx.strokeStyle = '#039BAF';
      ctx.arc(r, r, cR + 5, 0, 2 * Math.PI);
      ctx.stroke();
      ctx.beginPath();
      ctx.arc(r, r, cR, 0, 2 * Math.PI);
      ctx.clip();

    };
//画sin 曲线函数
    var drawSin = function (xOffset) {
      ctx.save();

      var points = [];  //用于存放绘制Sin曲线的点

      ctx.beginPath();
      //在整个轴长上取点
      for (var x = sX; x < sX + axisLength; x += 20 / axisLength) {
        //此处坐标(x,y)的取点，依靠公式 “振幅高*sin(x*振幅宽 + 振幅偏移量)”
        var y = -Math.sin((sX + x) * waveWidth + xOffset);

        var dY = mH * (1 - nowRange / 100);

        points.push([x, dY + y * waveHeight]);
        ctx.lineTo(x, dY + y * waveHeight);
      }

      //封闭路径
      ctx.lineTo(axisLength, mH);
      ctx.lineTo(sX, mH);
      ctx.lineTo(points[0][0], points[0][1]);
      ctx.fillStyle = '#039BAF';
      ctx.fill();

      ctx.restore();
    };
//写百分比文本函数
    var drawText = function () {
      ctx.save();
      var size = 0.4 * cR;
      ctx.font = size + 'px Microsoft Yahei';
      ctx.textAlign = 'center';
      ctx.fillStyle = '#FD7923';
      ctx.fillText(~~nowRange + '%', r, r + size / 2);

      ctx.restore();
    };

    function render() {
      ctx.clearRect(0, 0, mW, mH);
      if (IsdrawCircled == false) {
        drawCircle();
      }
      if (nowRange <= rangeValue) {
        var tmp = 1;
        nowRange += tmp;
      }

      if (nowRange > rangeValue) {
        var tmp = 1;
        nowRange -= tmp;
      }

      drawSin(xOffset);
      drawText();
      xOffset += speed;
      requestAnimationFrame(render);
    }

    $('.tips').show().textillate({
      loop: false,
      in: {
        effect: 'fadeInLeftBig',
        sequence: false,
        reverse: false,
        sync: false,
        shuffle: false,
        callback: function () {
          $('.ing').show().textillate({
            loop: false,
            in: {
              effect: 'bounceInRight',
              sequence: true,
              reverse: false,
              sync: false,
              shuffle: false,
              callback: function () {
                render();
                let loader = new PxLoader();
                imgarr.map((v) => {
                  loader.addImage(v);
                });
                loader.addProgressListener(function (e) {
                  rangeValue = Math.round(e.completedCount / e.totalCount * 100);
                  if (e.completedCount === imgarr.length) {
                    setTimeout(function () {
                      $('.loding_box').remove();
                      rends = true;
                      rool(0);
                    }, 1000);
                  }
                });
                loader.start();
              }
            }
          });
        }
      }
    });
  }();
  init();

  function init() {
    $.each($('.pm'), function (i, v) {
      lists.push({
        top: $(v).offset().top,
        flag: true
      });
    });
    $('.menu_box .menu span').on('click', function () {
      if (!$(this).hasClass('active')) {
        index = $(this).index();
        rool(index);
      }
    });
    $('.go_two').on('click', function () {
      index = 1;
      rool(index);
    });
    $(window).bind('mousewheel', function (e, d) {
      if (!rends) {
        return false;
      }
      var dir = d > 0 ? 'Up' : 'Down';
      if (dir == 'Up') {
        if (flag) {
          if (index == 0) {
            return false;
          }
          flag = false;
          index--;
          rool(index);
          setTimeout(function () {
            flag = true;
          }, 1000);
        }
      } else {
        if (flag) {
          if (index == lists.length - 1) {
            return false;
          }
          flag = false;
          index++;
          rool(index);
          setTimeout(function () {
            flag = true;
          }, 1000);
        }
      }
      return false;
    });
  }

  function rool(num) {
    $('.menu_box .menu span').removeClass('active').eq(num).addClass('active');
    if (num == 0 || num == 1) {
      $('.menu_box .menu').removeClass('active');
    } else {
      $('.menu_box .menu').addClass('active');
    }
    $('html,body').animate({'scrollTop': lists[num].top}, 600);
    if (!lists[num].flag) {
      return false;
    }
    lists[num].flag = false;
    if (num == 0) {
      var banner = new Swiper('.swiper-container', {
        direction: 'horizontal',
        effect: 'fade',
        noSwiping: true,
        onInit: function (swiper) {
          $('.swiper-slide').eq(swiper.activeIndex).find('h2').show().textillate({
            loop: false,
            in: {
              effect: 'fadeInLeftBig',
              sequence: false,
              reverse: false,
              sync: false,
              shuffle: false,
              callback: function () {
                banner.slideNext();
              }
            }
          });
        },
        onSlideChangeStart: function (swiper) {
          if (swiper.activeIndex == 1) {
            $('.swiper-slide').eq(swiper.activeIndex).find('h2').show().textillate({
              loop: false,
              in: {
                effect: 'rotateIn',
                sequence: true,
                reverse: false,
                sync: false,
                shuffle: false,
                callback: function () {
                  banner.slideNext();
                }
              }
            });
          } else if (swiper.activeIndex == 2) {
            var em = $('.swiper-slide').eq(swiper.activeIndex);
            em.find('h2').show().textillate({
              loop: false,
              in: {
                effect: 'shake',
                sequence: true,
                reverse: false,
                sync: false,
                shuffle: false,
                callback: function () {
                }
              }
            });
            em.find('h5').show().textillate({
              loop: false,
              in: {
                effect: 'fadeInRight',
                sequence: true,
                reverse: false,
                sync: false,
                shuffle: false,
                callback: function () {
                  em.find('img').show().addClass('elastic-in-down');
                }
              }
            });
          }
        }
      });
    } else if (num == 1) {
      //项目第一页 菜单的星空效果
      //生成小球对象
      var count = 60;
      var balls = [];
      for (var i = 0; i < count; i++) {
        var ball = new Ball();
        balls.push(ball);
      }
      var timer = setInterval(function () {
        //下面是小球移动的函数
        function startMove() {
          ctx.clearRect(0, 0, 2000, 400);
          for (var i = 0; i < balls.length; i++) {
            balls[i].draw();
            balls[i].move();
          }
          adjustballCanvas();
        }

        startMove();
        for (var i = 0; i < balls.length; i++) {
          //算出鼠标和小球中心之间的距离
          var subX = Math.abs(mouseX - balls[i].centerX);
          var subY = Math.abs(mouseY - balls[i].centerY);
          //判断鼠标点到小球中心的距离
          if (Math.sqrt(subX * subX + subY * subY) < areaRadius) {
            areaB.push(balls[i]);
          }
          if (mouseX < areaRadius) {
            mouseX = areaRadius;
          } else if (mouseY < areaRadius) {
            mouseY = areaRadius;
          } else if (mouseX > canvas1.width - areaRadius) {
            mouseX = canvas1.width - areaRadius;
          } else if (mouseY > canvas1.height - areaRadius) {
            mouseY = canvas1.height - areaRadius;
          }
        }
        areaBallLine();
        areaB = [];
      }, 100);

      //写一个方法,检测小球和canvas1画布碰撞的时候,将速度变成相反的
      function adjustballCanvas() {
        for (var i = 0; i < balls.length; i++) {
          //首先判断水平方向的
          if (balls[i].centerX < balls[i].radius || balls[i].centerX > (canvas1.width - balls[i].radius)) {
            balls[i].speedX *= -1;
          }
          if (balls[i].centerY < balls[i].radius || balls[i].centerY > (canvas1.height - balls[i].radius)) {
            balls[i].speedY *= -1;
          }
        }
      }

      $('.person').addClass('active').find('ul').delay(2000).queue(function () {
        $(this).addClass('active').delay(700).queue(function () {
          $(this).parents('.person').find('ol').addClass('active').dequeue();
        }).dequeue();
      });
    } else if (num == 2) {
      gline();
      $('.skill').addClass('active').find('.dial ul').delay(500).queue(function () {
        $(this).addClass('turning').delay(2000).queue(function () {
          $.each($('.skills'), function (i, v) {
            rend($(v).find('canvas').attr('id'));
          });

          $(this).removeClass('turn turning').addClass('active').dequeue();
        }).dequeue();
      });
    } else if (num == 3) {
      $('.noone').html('');
      var str = '<iframe src="3d/index.html" frameborder="0" style="width: 1200px;margin: 0 auto;height: 700px;display: block;"></iframe>';
      $(str).appendTo('.noone');
      $('.item h1').addClass('active');
      $('#da-thumbs1 > li').hoverdir();
      $('#da-thumbs2 > li').hoverdir();
      $('#da-thumbs3 > li').hoverdir();
      $('#da-thumbs4 > li').hoverdir();
      $('#da-thumbs5 > li').hoverdir();
      //    改变小导航的js
      var width = $(window).width();
      var num = $('.nav_li ul li').length;
      for (var i = 0; i <= 200; i++) {
        $('.nav_li ul').after('<div class="a" id="a' + i + '"></div>');
      }
      change();
      var nav_li = $('.nav_li ul li');
      var nav = nav_li.offset();
      $('.nav_li ul li').hover(function () {
        //console.log(x+","+y);
        $(this).addClass('active').siblings().removeClass('active');
        $('.experience .items').eq($(this).index()).addClass('active').siblings().removeClass('active');
        a = $(this).find('a').offset();
        b = $(this).next().find('a').offset();
        wid = $(this).width();
        for (var i = 0; i <= 200; i++) {
          if (i <= wid / 2) {
            $('#a' + i).css({
              transform: 'rotate(0deg)',
              top: 50,
              left: a.left + (i * 2),
              right: 0,
              bottom: 0,
              width: '2px',
              height: '1px',
              background: 'rgba(255, 255, 255,0.8)'
            });
          } else {
            $('#a' + i).css({
              transform: 'rotate(0deg)',
              top: a.top + 27,
              left: a.left + ((i - wid / 2 - 1) * 2),
              right: 0,
              bottom: 0,
              width: '4px',
              height: '1px',
              background: 'rgba(255, 255, 255,0.8)'
            });
          }
        }
      }, function () {
        change();
      });

      //分散那一堆点；
      function change() {
        for (var i = 0; i <= 200; i++) {
          var top = parseInt(100 * Math.random());
          var left = parseInt(width * Math.random());
          var right = parseInt(300 * Math.random());
          var bottom = parseInt(300 * Math.random());
          var transform = parseInt(360 * Math.random());
          $('#a' + i).css({
            transform: 'rotate(' + transform + 'deg)',
            top: top,
            left: left,
            right: right,
            bottom: bottom,
            transition: '0.5s',
            width: i / 40 + 'px',
            height: i / 40 + 'px',
            background: 'rgba(200, 200, 200,' + i / 200 + ')'
          });
        }
      }
    } else if (num == 4) {
      $('.contact').addClass('active').delay(500).queue(function () {
        var wef_arr = [
          {effect: 'flipInX', attr: '.a1', reverse: false, sync: false, shuffle: false, sequence: true},
          {effect: 'bounceIn', attr: '.a2', reverse: false, sync: false, shuffle: false, sequence: true},
          {effect: 'fadeInLeftBig', attr: '.a3', reverse: false, sync: false, shuffle: false},
          {effect: 'swing', attr: '.a4', reverse: false, sync: false, shuffle: false, sequence: true},
          {effect: 'bounceInRight', attr: '.a5', reverse: false, sync: false, shuffle: false, sequence: true}
        ];  //字体动画列表
        //字体动画
        var wef_id = 0;

        // 字体特效方法
        function wef_text(obj) {
          $(obj.attr).show().textillate({
            loop: false,
            in: {
              effect: obj.effect,
              sequence: obj.sequence,
              reverse: obj.reverse,
              sync: obj.sync,
              shuffle: obj.shuffle,
              callback: function () {
                wef_id++;
                if (wef_id < wef_arr.length) {
                  wef_text(wef_arr[wef_id]);
                } else {
                  $('.fly').addClass('active').delay(6000).queue(function () {
                    $('.tlt').show().textillate({
                      loop: false,
                      in: {
                        effect: 'rollIn',
                        reverse: false,
                        shuffle: false,
                        sync: false,
                        callback: function () {
                          $('.contact dl').show().addClass('elastic-x');
                        }
                      }
                    });
                    $(this).dequeue();
                  });
                }
              }
            }
          });
        }

        wef_text(wef_arr[0]);
        $(this).dequeue();
      });
    }
  }

  //第二页canvas的画线功能；
  function rend(id) {
    var num = 1 * id.slice(2, 4);
    var start = -0.4;
    var end = Math.PI * 2 - ((Math.PI * 2) / (100 / num));
    var elem = document.getElementById(id);
    var ctx = elem.getContext('2d');
    var end = Math.PI * 2 - ((Math.PI * 2) / (100 / num));
    //6.283
    var max = Math.PI * 2;
    var t = setInterval(function () {
      max -= 0.06;
      if (max < end) {
        clearInterval(t);
        arc(ctx, end);
      } else {
        arc(ctx, max);
      }
    }, 0.01);
  }

  function arc(ctx, end) {
    ctx.clearRect(0, 0, 140, 140);
    ctx.lineWidth = 5;
    ctx.beginPath();
    ctx.strokeStyle = '#404d5b';
    ctx.arc(70, 70, 60, 0, Math.PI * 2, true);
    ctx.stroke();
    ctx.closePath();
    ctx.beginPath();
    ctx.strokeStyle = '#d6be21';
    ctx.arc(70, 70, 60, 0, end, true);
    ctx.stroke();
    ctx.closePath();
  }

  function gline() {
    var elem = document.getElementById('bgs');
    var ctx = elem.getContext('2d');
    var max = 940;
    var min = 200;
    setInterval(function () {
      min += 3;
      if (min > max) {
        draw(ctx, max);
      } else {
        draw(ctx, min);
      }
    }, 0.1);
  }

  function draw(ctx, w) {
    ctx.clearRect(0, 0, 1080, 560);
    ctx.beginPath();
    ctx.lineWidth = 4;
    ctx.strokeStyle = '#d6be21';
    ctx.moveTo(200, 60);
    ctx.lineTo(w, 60);
    ctx.closePath();
    ctx.stroke();
    ctx.beginPath();
    ctx.lineWidth = 4;
    ctx.strokeStyle = '#d6be21';
    ctx.moveTo(820, 40);
    ctx.lineTo(680, 500);
    ctx.closePath();
    ctx.stroke();
  }
});

//music
function playAudio() {
  var audio1 = $('audio').get(0);
  audio1.play();
  audio1.volume = 0.2;
  audio1.onended = function () {
    audio1.currentTime = 0;
    audio1.play();
  };
}


