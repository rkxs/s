var canvas1 = document.getElementById("canvas1");
var ctx = canvas1.getContext("2d");

//声明变量记录小球的最小半径和最大半径
var min = 1,
    max = 2;
//首选定义构造函数,生成小球对象
function Ball() {
    this.centerX = randomNumber(max, canvas1.width - max);
    this.centerY = randomNumber(max, canvas1.height - max);
    this.radius = randomNumber(min, max);
    this.color = randomColor();
    //水平方向的速度
    var speed1 = randomNumber(1, 3);
    this.speedX = randomNumber(0, 1) == 0 ? -speed1 : speed1;
    //竖直方向的速度
    var speed2 = randomNumber(1, 3);
    this.speedY = randomNumber(0, 1) == 0 ? -speed2 : speed2;
}
//添加绘制小球的方法
Ball.prototype.draw = function() {
    ctx.beginPath();
    ctx.arc(this.centerX, this.centerY, this.radius, 0, Math.PI * 2, false);
    ctx.closePath();
    ctx.fillStyle = this.color;
    ctx.fill();
}
//给小球添加鼠移动的事件
Ball.prototype.move = function() {
    this.centerX += this.speedX;
    this.centerY += this.speedY;
}
//定义一个空数组,存放一定距离内，连线的小球
var areaB = [];
//定义一个变量,用来存储范围
var areaRadius =150;
//写一个函数
//写一个鼠标移入的事件,求一开始的位置
var mouseX = 500;
var mouseY = 300;

$("#canvas1").on("mousemove", function(e) {
    var even = e || event;
    //获取鼠标的坐标点
    mouseX = even.pageX - $("#canvas1").offset().left;
    mouseY = even.pageY - $("#canvas1").offset().top;
});
//小球与小球之间的连线
function areaBallLine() {
    //在一定区域内绘制一个大圆球
    for(var i = 0; i < areaB.length; i++) {
        for(var j = 0; j < areaB.length; j++) {
            var disX = Math.abs(areaB[i].centerX - areaB[j].centerX);
            var disY = Math.abs(areaB[i].centerY - areaB[j].centerY);
            if(Math.sqrt(disX * disX + disY * disY) < 60) {
                //开始绘制线段
                ctx.beginPath();
                ctx.moveTo(areaB[i].centerX, areaB[i].centerY);
                ctx.lineTo(areaB[j].centerX, areaB[j].centerY);
                ctx.closePath();
                ctx.strokeStyle = randomColor();
                ctx.stroke();
            }
        }
    }
}
//生成随机数的函数
function randomNumber(x, y) {
    return Math.floor(Math.random() * (y - x + 1) + x);
}
//生成随机颜色的函数
function randomColor() {
    var red = randomNumber(0, 255);
    var green = randomNumber(0, 255);
    var blue = randomNumber(0, 255);
    return "rgb(" + red + "," + green + "," + blue + ")";
}