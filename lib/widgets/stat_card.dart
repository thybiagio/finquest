import 'package:flutter/material.dart';

class StatCard extends StatelessWidget { 
    const StatCard({ 
        super.key,
        required this.label,
        required this.value,
        this.valueColor,
    });

    final String label;
    final String value;
    final Color? valueColor;

    @override
    Widget build(BuildContext context) { 
        return Container( 
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration( 
                color: Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(16),
            ),
            child: Column( 
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [ 
                    Text( 
                        label, 
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text( 
                        value,
                        style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold, 
                            color: valueColor ?? Colors.black87,
                        ),
                    ),
                ],
            ),
        );
    }
}