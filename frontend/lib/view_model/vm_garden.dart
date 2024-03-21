FutureBuilder<List<Garden>>(
  future: fetchGarden(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        return Text("Error: ${snapshot.error}");
      }
      return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(snapshot.data[index].name),
            subtitle: Text(snapshot.data[index].email),
          );
        },
      );
    } else {
      return CircularProgressIndicator();
    }
  },
)

