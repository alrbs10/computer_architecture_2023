void bubble_sort(int list[], int n){
  int i, j, temp;
  for(i=n-1; i>0; i--){
    for(j=0; j<i; j++){
      if(list[j]<list[j+1]){
        temp = list[j];
        list[j] = list[j+1];
        list[j+1] = temp;
      }
    }
  }
}