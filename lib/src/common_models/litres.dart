class Litres {
  final double value;

  const Litres(this.value);

  Litres operator +(Litres other) => Litres(other.value + value);
  Litres operator -(Litres other) => Litres(other.value - value);
  Litres operator *(double other) => Litres(other * value);
}
