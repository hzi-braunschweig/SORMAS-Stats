from sormas import PersonDto


class Person(PersonDto):
    def __str__(self):
        return f"{self.first_name} {self.last_name}"

    def __repr__(self):
        return self.__str__()
