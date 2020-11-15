// Calculate Momentum
int main(){
    int mass, velocity, momentum;
    printStr("_____________ Calculating Momentum _____________\n");
    int err = 1;
    printStr("Input mass:");
    mass = readInt(&err);
    printStr("Input velocity:");
    velocity = readInt(&err);
    momentum = mass*velocity;
    printStr("The value of momentum is ");
    printInt(momentum);
    printStr("\n__________________________\n");
    return 0;
}