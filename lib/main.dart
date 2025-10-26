import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Xóa biểu ngữ gỡ lỗi
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Các biến để lưu trữ trạng thái của máy tính
  String _history = ""; // Dòng hiển thị lịch sử phép tính.
  String _output = "0"; // Màn hình chính, hiển thị số đang nhập hoặc kết quả.
  String _currentNumber = ""; // Số hiện đang được nhập.
  double _num1 = 0; // Toán hạng đầu tiên trong một phép tính.
  String _operator = ""; // Toán tử đã chọn (+, -, x, /).

  // Logic chính xử lý việc nhấn nút.
  void _buttonPressed(String buttonText) {
    if (buttonText == "C") {
      _clear();
    } else if (buttonText == "+" ||
        buttonText == "-" ||
        buttonText == "/" ||
        buttonText == "x") {
      _selectOperator(buttonText);
    } else if (buttonText == "=") {
      _calculate();
    } else {
      _appendNumber(buttonText);
    }
  }

  // Hàm trợ giúp để định dạng số (bỏ .0 nếu là số nguyên)
  String _formatNumber(double n) {
    if (n.truncateToDouble() == n) {
      return n.toInt().toString();
    } else {
      return n.toString();
    }
  }

  // Đặt lại máy tính về trạng thái ban đầu.
  void _clear() {
    setState(() {
      _history = "";
      _output = "0";
      _currentNumber = "";
      _num1 = 0;
      _operator = "";
    });
  }

  // Nối một chữ số hoặc dấu thập phân vào số hiện tại.
  void _appendNumber(String number) {
    setState(() {
      // Nếu phép tính vừa kết thúc, bắt đầu một số mới
      if (_operator.isEmpty && _currentNumber.isEmpty) {
        _output = "0";
        _history = "";
      }
      if (_currentNumber.contains('.') && number == '.') return;

      _currentNumber += number;
      _output = _currentNumber;
    });
  }

  // Chọn một toán tử và thực hiện phép tính chuỗi.
  void _selectOperator(String newOperator) {
    setState(() {
      // Xử lý các phép tính chuỗi (ví dụ: "3 + 4 *")
      if (_operator.isNotEmpty && _currentNumber.isNotEmpty) {
        _calculate(); // Tính kết quả trước, sau đó tiếp tục
      }
      
      if (_currentNumber.isNotEmpty) {
        _num1 = double.parse(_currentNumber);
        _currentNumber = "";
      }
      
      _operator = newOperator;
      _history = '${_formatNumber(_num1)} $_operator';
      _output = _formatNumber(_num1);
    });
  }

  // Thực hiện phép tính cuối cùng cho nút "=".
  void _calculate() {
    setState(() {
      if (_currentNumber.isEmpty || _operator.isEmpty) return;

      double num2 = double.parse(_currentNumber);
      double result = _num1;

      if (_operator == "+") result += num2;
      if (_operator == "-") result -= num2;
      if (_operator == "x") result *= num2;
      if (_operator == "/") result /= num2;

      _history = '${_formatNumber(_num1)} $_operator ${_formatNumber(num2)} =';
      _output = _formatNumber(result);

      _num1 = result;
      _currentNumber = "";
      _operator = "";
    });
  }

  // Hàm trợ giúp để tạo một nút máy tính duy nhất.
  Widget _buildButton(String buttonText) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(), // Nút hình tròn
            padding: const EdgeInsets.all(24.0), // Padding bên trong nút
            backgroundColor: Colors.orange, // Nền màu cam
            foregroundColor: Colors.white, // Chữ màu trắng
            side: BorderSide.none, // Bỏ đường viền
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // Bố cục chính của ứng dụng, sắp xếp các widget theo chiều dọc.
      body: Column(
        children: <Widget>[
          // Khu vực hiển thị được mở rộng, chiếm toàn bộ không gian còn lại phía trên.
          Expanded(
            child: Column(
              // Căn chỉnh các dòng text về phía cuối của khu vực này.
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Dòng hiển thị lịch sử phép tính (nhỏ hơn và màu xám).
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    _history,
                    style: const TextStyle(fontSize: 24.0, color: Colors.grey),
                  ),
                ),
                // Dòng hiển thị chính (số đang nhập hoặc kết quả cuối cùng).
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                  child: Text(
                    _output,
                    style: const TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Đường kẻ ngang để phân chia màn hình và các nút bấm.
          const Divider(thickness: 1),
          // Vùng chứa lưới các nút bấm.
          Column(
            children: [
              // Mỗi Row là một hàng các nút bấm, được tạo bằng hàm _buildButton.
              // Expanded trong _buildButton đảm bảo mỗi nút chiếm không gian bằng nhau trong hàng.
              Row(children: <Widget>[_buildButton("7"), _buildButton("8"), _buildButton("9"), _buildButton("/")]),
              Row(children: <Widget>[_buildButton("4"), _buildButton("5"), _buildButton("6"), _buildButton("x")]),
              Row(children: <Widget>[_buildButton("1"), _buildButton("2"), _buildButton("3"), _buildButton("-")]),
              Row(children: <Widget>[_buildButton("."), _buildButton("0"), _buildButton("C"), _buildButton("+")]),
              Row(children: <Widget>[Expanded(child: _buildButton("="))]), // Nút = được bọc trong Expanded để chiếm cả hàng.
            ],
          )
        ],
      ),
    );
  }
}
