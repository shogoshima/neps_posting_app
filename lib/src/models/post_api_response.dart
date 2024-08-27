import 'models.dart';

class PostApiResponse {
  final int page;
  final int pages;
  final List<Post> posts;
  final int total;

  PostApiResponse(
      {required this.page,
      required this.pages,
      required this.posts,
      required this.total});

  factory PostApiResponse.fromJson(Map<String, dynamic> json) {
    final posts = <Post>[];
    for (final post in json['posts']) {
      posts.add(Post.fromJson(post));
    }
    return PostApiResponse(
      page: json['page'],
      pages: json['pages'],
      posts: posts,
      total: json['total'],
    );
  }

  @override
  String toString() {
    return 'PostApiResponse{page: $page, pages: $pages, posts: $posts, total: $total}';
  }
}
