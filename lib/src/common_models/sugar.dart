class Blg {
  final double value;

  const Blg(this.value);
}

class Kilograms {
  final double value;

  const Kilograms(this.value);

  Kilograms operator +(Kilograms other) => Kilograms(other.value + value);
  Kilograms operator -(Kilograms other) => Kilograms(other.value - value);
}
