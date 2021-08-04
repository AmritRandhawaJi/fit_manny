

class Slide{

String title;
String description;
String image;

Slide({required this.title, required this.description, required this.image});
}

final slideList = [
  Slide(title: "Fitness", description: "We believe fitness is a part of life", image: "images/fitness.png"),
  Slide(title: "Nutrition", description: "We provide you best nutrition plan to achieve your goals", image: "images/track.png"),
  Slide(title: "Training", description: "Our customised training schedules help you to get in shape in no time", image: "images/exercise.png"),
];


